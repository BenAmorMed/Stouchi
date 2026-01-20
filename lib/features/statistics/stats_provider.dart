import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/daily_statistic_model.dart';
import '../auth/auth_provider.dart';

// Stream of daily statistics for the logged-in user
final userDailyStatsProvider = StreamProvider<List<DailyStatisticModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('daily_statistics')
      .where('userId', isEqualTo: user.uid)
      .orderBy('date', descending: true)
      .limit(7) // Last 7 days as per requirements
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Stream of aggregated statistics for admin (all users)
final adminAggregateStatsProvider = StreamProvider<List<DailyStatisticModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('daily_statistics')
      .orderBy('date', descending: false) // ASC for charts
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Group admin stats by date (summing all users per day)
final dailyGroupedStatsProvider = Provider<List<DailyStatisticModel>>((ref) {
  final allStats = ref.watch(adminAggregateStatsProvider).value ?? [];
  final Map<String, DailyStatisticModel> grouped = {};

  for (var stat in allStats) {
    final dateStr = stat.date.toIso8601String().split('T')[0];
    if (grouped.containsKey(dateStr)) {
      final existing = grouped[dateStr]!;
      // Merge article stats too
      final mergedArticles = Map<String, ArticleDailyStats>.from(existing.articleStats);
      stat.articleStats.forEach((id, article) {
        if (mergedArticles.containsKey(id)) {
          mergedArticles[id] = mergedArticles[id]!.copyWith(
            qty: mergedArticles[id]!.qty + article.qty,
            revenue: mergedArticles[id]!.revenue + article.revenue,
            profit: mergedArticles[id]!.profit + article.profit,
          );
        } else {
          mergedArticles[id] = article;
        }
      });

      grouped[dateStr] = existing.copyWith(
        sales: existing.sales + stat.sales,
        profit: existing.profit + stat.profit,
        tips: existing.tips + stat.tips,
        orderCount: existing.orderCount + stat.orderCount,
        articleStats: mergedArticles,
      );
    } else {
      grouped[dateStr] = stat;
    }
  }
  return grouped.values.toList()..sort((a, b) => a.date.compareTo(b.date));
});

// Aggregate top articles across all days
final topArticlesProvider = Provider<List<ArticleDailyStats>>((ref) {
  final allStats = ref.watch(adminAggregateStatsProvider).value ?? [];
  final Map<String, ArticleDailyStats> aggregated = {};

  for (var daily in allStats) {
    daily.articleStats.forEach((id, article) {
      if (aggregated.containsKey(id)) {
        aggregated[id] = aggregated[id]!.copyWith(
          qty: aggregated[id]!.qty + article.qty,
          revenue: aggregated[id]!.revenue + article.revenue,
          profit: aggregated[id]!.profit + article.profit,
        );
      } else {
        aggregated[id] = article;
      }
    });
  }
  return aggregated.values.toList()..sort((a, b) => b.profit.compareTo(a.profit)); // Sort by profit DESC
});
