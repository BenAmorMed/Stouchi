import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/daily_statistic_model.dart';
import '../../core/models/hourly_statistic_model.dart';
import '../../core/models/order_model.dart';
import '../auth/auth_provider.dart';

enum StatsPeriod { day, week, month }

// --- State Providers ---

final statsPeriodProvider = StateProvider<StatsPeriod>((ref) => StatsPeriod.day);
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedHourProvider = StateProvider<int?>((ref) => null);

// --- Data Providers ---

// 1. Fetch Orders for the specific selected Day (Raw Data for Hourly breakdown)
final specificDayOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  
  // Start of day: 00:00:00
  final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  // End of day: 23:59:59.999
  final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59, 999);

  return FirebaseFirestore.instance
      .collection('orders')
      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
      .where('status', isEqualTo: OrderStatus.completed.name)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// 2. Aggregate Orders into Hourly Stats
final hourlyStatsProvider = Provider<List<HourlyStatistic>>((ref) {
  final orders = ref.watch(specificDayOrdersProvider).value ?? [];
  
  // Initialize map for 0-23 hours
  final Map<int, HourlyStatistic> hourlyMap = {
    for (var i = 0; i < 24; i++) i: HourlyStatistic(hour: i)
  };

  for (final order in orders) {
    final hour = order.timestamp.hour;
    final currentStat = hourlyMap[hour]!;
    
    // Calculate profit (Revenue - Cost)
    // Note: Cost needs to be derived. In existing Service, Profit is calculated during completion.
    // However, OrderModel items contain 'costPrice' if processed correctly.
    // Let's assume OrderItemModel has costPrice populated during checkout (which it is in OrderService).
    final orderCost = order.items.fold(0.0, (acc, item) => acc + (item.costPrice * item.quantity));
    final orderProfit = order.total - orderCost; // Simplified profit calculation

    // Update User Stats for this hour
    final userSales = Map<String, double>.from(currentStat.userSales);
    final userProfit = Map<String, double>.from(currentStat.userProfit);
    
    userSales[order.userId] = (userSales[order.userId] ?? 0.0) + order.total;
    userProfit[order.userId] = (userProfit[order.userId] ?? 0.0) + orderProfit;
    
    // Update Article Stats for this hour
    final articleStats = Map<String, ArticleDailyStats>.from(currentStat.articleStats);
    for (final item in order.items) {
      final itemProfit = (item.price * item.quantity) - (item.costPrice * item.quantity);
      if (articleStats.containsKey(item.articleId)) {
        articleStats[item.articleId] = articleStats[item.articleId]!.copyWith(
          qty: articleStats[item.articleId]!.qty + item.quantity,
          revenue: articleStats[item.articleId]!.revenue + (item.price * item.quantity),
          profit: articleStats[item.articleId]!.profit + itemProfit,
        );
      } else {
        articleStats[item.articleId] = ArticleDailyStats(
          name: item.articleName,
          qty: item.quantity,
          revenue: item.price * item.quantity,
          profit: itemProfit,
        );
      }
    }

    hourlyMap[hour] = currentStat.copyWith(
      sales: currentStat.sales + order.total,
      profit: currentStat.profit + orderProfit,
      orderCount: currentStat.orderCount + 1,
      userSales: userSales,
      userProfit: userProfit,
      articleStats: articleStats,
    );
  }

  return hourlyMap.values.toList();
});


// 3. Fetch Daily Statistics for Week/Month range (Aggregated pre-calculated data)
final filteredRangeStatsProvider = StreamProvider<List<DailyStatisticModel>>((ref) {
  final period = ref.watch(statsPeriodProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  
  DateTime startDate;
  DateTime endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

  if (period == StatsPeriod.week) {
    // Last 7 days including selected date
    startDate = selectedDate.subtract(const Duration(days: 6));
  } else if (period == StatsPeriod.month) {
    // Current month (1st to last day of month)
    startDate = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    endDate = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
  } else {
    return const Stream.empty();
  }

  // Ensure start date is at 00:00:00
  startDate = DateTime(startDate.year, startDate.month, startDate.day);

  return FirebaseFirestore.instance
      .collection('daily_statistics')
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
      .orderBy('date', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});


// --- Combined "Main" Provider for UI ---
// This provider returns a single unified view of "Current Stats" based on selection.
// We map it to DailyStatisticModel structure for easier consumption by existing UI widgets,
// even if it's actually a single hour's data masquerading as a "Daily" stat.

class StatsViewState {
  final double totalSales;
  final double totalProfit;
  final int totalOrders;
  final List<DailyStatisticModel> trendData; // For charts (list of days or list of hours masquerading as days)
  final List<ArticleDailyStats> topArticles;
  final Map<String, double> userSales;
  final Map<String, double> userProfit;
  final bool isHourly;

  StatsViewState({
    required this.totalSales,
    required this.totalProfit,
    required this.totalOrders,
    required this.trendData,
    required this.topArticles,
    required this.userSales,
    required this.userProfit,
    this.isHourly = false,
  });
}

final adminStatsViewProvider = Provider.autoDispose<AsyncValue<StatsViewState>>((ref) {
  final period = ref.watch(statsPeriodProvider);
  final selectedHour = ref.watch(selectedHourProvider);
  
  // 1. DAY VIEW LOGIC
  if (period == StatsPeriod.day) {
    // Wait for hourly stats
    final hourlyStats = ref.watch(hourlyStatsProvider); // List<HourlyStatistic> (0-23)
    // Check loading state of orders
    final ordersAsync = ref.watch(specificDayOrdersProvider);
    if (ordersAsync.isLoading) return const AsyncValue.loading();
    if (ordersAsync.hasError) return AsyncValue.error(ordersAsync.error!, ordersAsync.stackTrace!);

    if (selectedHour != null) {
      // -- SINGLE HOUR View --
      final stat = hourlyStats[selectedHour];
      return AsyncValue.data(StatsViewState(
        totalSales: stat.sales,
        totalProfit: stat.profit,
        totalOrders: stat.orderCount,
        trendData: [], // Not needed for single hour overview
        topArticles: stat.articleStats.values.toList()..sort((a, b) => b.profit.compareTo(a.profit)),
        userSales: stat.userSales,
        userProfit: stat.userProfit,
        isHourly: true,
      ));
    } else {
      // -- FULL DAY View --
      double totalSales = 0;
      double totalProfit = 0;
      int totalOrders = 0;
      final Map<String, ArticleDailyStats> allArticles = {};
      final Map<String, double> allUserSales = {};
      final Map<String, double> allUserProfit = {};

      for (var stat in hourlyStats) {
        totalSales += stat.sales;
        totalProfit += stat.profit;
        totalOrders += stat.orderCount;
        
        stat.articleStats.forEach((k, v) {
          if (allArticles.containsKey(k)) {
            allArticles[k] = allArticles[k]!.copyWith(
              qty: allArticles[k]!.qty + v.qty,
              revenue: allArticles[k]!.revenue + v.revenue,
              profit: allArticles[k]!.profit + v.profit,
            );
          } else {
            allArticles[k] = v;
          }
        });

        stat.userSales.forEach((u, s) => allUserSales[u] = (allUserSales[u] ?? 0) + s);
        stat.userProfit.forEach((u, p) => allUserProfit[u] = (allUserProfit[u] ?? 0) + p);
      }

      return AsyncValue.data(StatsViewState(
        totalSales: totalSales,
        totalProfit: totalProfit,
        totalOrders: totalOrders,
        trendData: [], // Provide hourly data separately if needed for chart
        topArticles: allArticles.values.toList()..sort((a, b) => b.profit.compareTo(a.profit)),
        userSales: allUserSales,
        userProfit: allUserProfit,
        isHourly: false,
      ));
    }
  } 
  
  // 2. WEEK/MONTH VIEW LOGIC
  else {
    final rangeStatsAsync = ref.watch(filteredRangeStatsProvider);
    
    return rangeStatsAsync.when(
      data: (stats) {
        double totalSales = 0;
        double totalProfit = 0;
        int totalOrders = 0;
        final Map<String, ArticleDailyStats> allArticles = {};
        final Map<String, double> allUserSales = {};
        // Note: DailyStatisticModel aggregates user stats inside itself? 
        // Actually, existing DailyStatisticModel structure:
        // 'userId' (string) -> The daily stats doc ID is 'userId_date'.
        // So each document is for ONE user for ONE day.
        
        // Wait, the existing `adminAggregateStatsProvider` fetches ALL docs.
        // My `filteredRangeStatsProvider` also fetches ALL docs in range.
        // So `stats` is a list of [User A Day 1, User B Day 1, User A Day 2...]
        
        final Map<String, double> allUserProfit = {};

        for (var stat in stats) {
           totalSales += stat.sales;
           totalProfit += stat.profit;
           totalOrders += stat.orderCount;
           
           // Aggregate User Totals
           allUserSales[stat.userId] = (allUserSales[stat.userId] ?? 0) + stat.sales;
           allUserProfit[stat.userId] = (allUserProfit[stat.userId] ?? 0) + stat.profit;

           // Aggregate Articles
           stat.articleStats.forEach((k, v) {
              if (allArticles.containsKey(k)) {
                allArticles[k] = allArticles[k]!.copyWith(
                  qty: allArticles[k]!.qty + v.qty,
                  revenue: allArticles[k]!.revenue + v.revenue,
                  profit: allArticles[k]!.profit + v.profit,
                );
              } else {
                allArticles[k] = v;
              }
           });
        }
        
        // For Trend Chart, we need to group by Date
        final Map<String, DailyStatisticModel> groupedByDate = {};
        for (var stat in stats) {
           final dateKey = stat.date.toIso8601String().split('T')[0];
           if (groupedByDate.containsKey(dateKey)) {
             final prev = groupedByDate[dateKey]!;
             groupedByDate[dateKey] = prev.copyWith(
               sales: prev.sales + stat.sales,
               profit: prev.profit + stat.profit,
             );
           } else {
             groupedByDate[dateKey] = DailyStatisticModel(
               id: 'temp', userId: 'consolidated', date: stat.date, 
               sales: stat.sales, profit: stat.profit,
             );
           }
        }

        final sortedTrend = groupedByDate.values.toList()..sort((a,b) => a.date.compareTo(b.date));

        return AsyncValue.data(StatsViewState(
          totalSales: totalSales,
          totalProfit: totalProfit,
          totalOrders: totalOrders,
          trendData: sortedTrend,
          topArticles: allArticles.values.toList()..sort((a, b) => b.profit.compareTo(a.profit)),
          userSales: allUserSales,
          userProfit: allUserProfit,
          isHourly: false,
        ));
      },
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
    );
  }
});

// Stream of daily statistics for the logged-in user (Restored)
final userDailyStatsProvider = StreamProvider<List<DailyStatisticModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('daily_statistics')
      .where('userId', isEqualTo: user.uid)
      .orderBy('date', descending: true)
      .limit(7)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

