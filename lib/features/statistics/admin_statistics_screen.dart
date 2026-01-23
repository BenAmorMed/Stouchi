import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'stats_provider.dart';
import '../auth/auth_provider.dart';
import 'history_archive_screen.dart';
import '../../services/history_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_model.dart';

import '../../core/models/daily_statistic_model.dart';

final historyServiceProvider = Provider((ref) => HistoryService());

class AdminStatisticsScreen extends ConsumerWidget {
  const AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsStateAsync = ref.watch(adminStatsViewProvider);
    final usersAsync = ref.watch(allUsersProvider);
    final period = ref.watch(statsPeriodProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedHour = ref.watch(selectedHourProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryArchiveScreen()),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Date & Period Controls ---
            _buildControls(context, ref, period, selectedDate),
            const SizedBox(height: 24),

            statsStateAsync.when(
              data: (state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // --- KPIs ---
                  const Text(
                    'Key Performance Indicators',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildKPIs(state.totalSales, state.totalProfit, state.totalOrders),
                  
                  const SizedBox(height: 32),
                  
                  // --- Chart Section ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        period == StatsPeriod.day 
                            ? (selectedHour != null ? 'Hourly Breakdown ($selectedHour:00)' : 'Hourly Breakdown')
                            : 'Sales vs Profit Trend',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (period == StatsPeriod.day && selectedHour != null)
                        TextButton.icon(
                          onPressed: () => ref.read(selectedHourProvider.notifier).state = null,
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Clear Hour'),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (period == StatsPeriod.day)
                    _buildHourlyChart(ref, selectedHour)
                  else
                    _buildTrendChart(state.trendData),

                  const SizedBox(height: 32),

                  // --- Top Articles ---
                  const Text(
                    'Top Profitable Articles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTopArticlesChart(state.topArticles.take(5).toList()),

                  const SizedBox(height: 48),

                  // --- User Breakdown ---
                  const Text(
                    'User Contributions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildUserBreakdown(usersAsync, state.userSales, state.userProfit, context, ref),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, WidgetRef ref, StatsPeriod period, DateTime selectedDate) {
    return Card(
      elevation: 0,
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Period Selector
            SegmentedButton<StatsPeriod>(
              segments: const [
                ButtonSegment(value: StatsPeriod.day, label: Text('Day'), icon: Icon(Icons.calendar_today)),
                ButtonSegment(value: StatsPeriod.week, label: Text('Week'), icon: Icon(Icons.date_range)),
                ButtonSegment(value: StatsPeriod.month, label: Text('Month'), icon: Icon(Icons.calendar_month)),
              ],
              selected: {period},
              onSelectionChanged: (Set<StatsPeriod> newSelection) {
                ref.read(statsPeriodProvider.notifier).state = newSelection.first;
                ref.read(selectedHourProvider.notifier).state = null; // Reset hour when changing period
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.primaryColor.withValues(alpha: 0.2);
                  }
                  return Colors.transparent;
                }),
              ),
            ),
            const SizedBox(height: 12),
            // Date Navigator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final newDate = period == StatsPeriod.month 
                        ? DateTime(selectedDate.year, selectedDate.month - 1, 1)
                        : selectedDate.subtract(const Duration(days: 1));
                    ref.read(selectedDateProvider.notifier).state = newDate;
                  },
                ),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      ref.read(selectedDateProvider.notifier).state = picked;
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          _formatDateRange(period, selectedDate),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                         Icon(Icons.edit_calendar, size: 16, color: AppTheme.mutedTextColor),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                   onPressed: selectedDate.isAfter(DateTime.now().subtract(const Duration(days: 1))) && period == StatsPeriod.day 
                       // Disable forward if today (logic can be improved but kept simple)
                       ? null 
                       : () {
                          final newDate = period == StatsPeriod.month 
                              ? DateTime(selectedDate.year, selectedDate.month + 1, 1)
                              : selectedDate.add(const Duration(days: 1));
                          if (newDate.isAfter(DateTime.now())) return; // Prevent future
                          ref.read(selectedDateProvider.notifier).state = newDate;
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange(StatsPeriod period, DateTime date) {
    if (period == StatsPeriod.day) {
      return DateFormat('EEE, MMM d, yyyy').format(date);
    } else if (period == StatsPeriod.week) {
      final start = date.subtract(const Duration(days: 6));
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d').format(date)}';
    } else {
      return DateFormat('MMMM yyyy').format(date);
    }
  }

  Widget _buildHourlyChart(WidgetRef ref, int? selectedHour) {
    final hourlyStats = ref.watch(hourlyStatsProvider); 
    
    // Determine max Y for scale
    double maxY = 100;
    if (hourlyStats.isNotEmpty) {
      final maxSales = hourlyStats.map((e) => e.sales).reduce((curr, next) => curr > next ? curr : next);
      maxY = (maxSales * 1.2).clamp(100.0, double.infinity);
    }

    return Card(
      elevation: 0,
       color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
         padding: const EdgeInsets.all(16),
         child: SizedBox(
           height: 250,
           child: BarChart(
             BarChartData(
               alignment: BarChartAlignment.spaceAround,
               maxY: maxY,
               barTouchData: BarTouchData(
                 enabled: true,
                 touchCallback: (FlTouchEvent event, barTouchResponse) {
                   if (!event.isInterestedForInteractions ||
                       barTouchResponse == null ||
                       barTouchResponse.spot == null) {
                     return;
                   }
                   if (event is FlTapUpEvent) {
                      final touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                      final hour = hourlyStats[touchedIndex].hour;
                      // Toggle
                      if (selectedHour == hour) {
                        ref.read(selectedHourProvider.notifier).state = null;
                      } else {
                        ref.read(selectedHourProvider.notifier).state = hour;
                      }
                   }
                 },
                 touchTooltipData: BarTouchTooltipData(
                   getTooltipColor: (_) => AppTheme.surfaceColor,
                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
                     final stat = hourlyStats[groupIndex];
                     return BarTooltipItem(
                       '${stat.hour}:00\n',
                       const TextStyle(fontWeight: FontWeight.bold),
                       children: [
                         TextSpan(
                           text: '\$${stat.sales.toStringAsFixed(0)}',
                           style: const TextStyle(color: Colors.blue),
                         ),
                       ],
                     );
                   },
                 ),
               ),
               titlesData: FlTitlesData(
                 show: true,
                 bottomTitles: AxisTitles(
                   sideTitles: SideTitles(
                     showTitles: true,
                     getTitlesWidget: (value, meta) {
                       final index = value.toInt();
                       if (index % 4 != 0) return const SizedBox.shrink(); // Show every 4 hours
                       return Padding(
                         padding: const EdgeInsets.only(top: 8),
                         child: Text('${index.toString().padLeft(2, '0')}:00', style: const TextStyle(fontSize: 10)),
                       );
                     },
                     reservedSize: 30,
                   ),
                 ),
                 leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                 topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                 rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
               ),
               gridData: const FlGridData(show: false),
               borderData: FlBorderData(show: false),
               barGroups: hourlyStats.map((stat) {
                 final isSelected = selectedHour == stat.hour;
                 return BarChartGroupData(
                   x: stat.hour,
                   barRods: [
                     BarChartRodData(
                       toY: stat.sales,
                       color: isSelected ? Colors.orange : Colors.blue,
                       width: 12,
                       borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                       backDrawRodData: BackgroundBarChartRodData(
                         show: true,
                         toY: maxY,
                         color: Colors.grey.withValues(alpha: 0.1),
                       ),
                     ),
                   ],
                 );
               }).toList(),
             ),
           ),
         ),
      ),
    );
  }

  Widget _buildTrendChart(List<DailyStatisticModel> groupedStats) {
    if (groupedStats.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No data available')));
    }

    // Determine max Y for scale
    final maxSales = groupedStats.map((e) => e.sales).fold(0.0, (curr, next) => curr > next ? curr : next);
    final maxY = (maxSales * 1.2).clamp(100.0, double.infinity);

    return Card(
      elevation: 0,
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              maxY: maxY,
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 || value.toInt() >= groupedStats.length) return const Text('');
                      final date = groupedStats[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(DateFormat('MM/dd').format(date), style: const TextStyle(fontSize: 10)),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Sales Line
                LineChartBarData(
                  spots: groupedStats.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.sales)).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: Colors.blue.withValues(alpha: 0.1)),
                ),
                // Profit Line
                LineChartBarData(
                  spots: groupedStats.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.profit)).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: Colors.green.withValues(alpha: 0.1)),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                   getTooltipColor: (_) => AppTheme.surfaceColor,
                   getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isSales = spot.barIndex == 0;
                        return LineTooltipItem(
                          '${isSales ? "Sales" : "Profit"}: \$${spot.y.toStringAsFixed(2)}',
                          TextStyle(color: isSales ? Colors.blue : Colors.green, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                   }
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKPIs(double sales, double profit, int orders) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _KPIItem(
            title: 'Revenue',
            value: '\$${sales.toStringAsFixed(2)}',
            icon: Icons.attach_money_rounded,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          _KPIItem(
            title: 'Profit',
            value: '\$${profit.toStringAsFixed(2)}',
            icon: Icons.trending_up_rounded,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          _KPIItem(
            title: 'Orders',
            value: '$orders',
            icon: Icons.receipt_long_rounded,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTopArticlesChart(List<ArticleDailyStats> topArticles) {
    if (topArticles.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No sales data yet')));
    }

    double maxY = 100;
     if (topArticles.isNotEmpty) {
      final maxVal = topArticles.map((e) => e.revenue > e.profit ? e.revenue : e.profit).reduce((curr, next) => curr > next ? curr : next);
      maxY = (maxVal * 1.2).clamp(100.0, double.infinity);
    }

    return Card(
      elevation: 0,
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 || value.toInt() >= topArticles.length) return const Text('');
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          topArticles[value.toInt()].name, 
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: topArticles.asMap().entries.map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.profit,
                    color: Colors.green,
                    width: 20,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                   BarChartRodData(
                    toY: e.value.revenue,
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 20,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserBreakdown(
    AsyncValue<List<UserModel>> usersAsync, 
    Map<String, double> userSalesMap, 
    Map<String, double> userProfitMap, 
    BuildContext context, 
    WidgetRef ref
  ) {
    return usersAsync.when(
      data: (users) {
        final sortedUsers = List<UserModel>.from(users);
        sortedUsers.sort((a, b) {
          final salesA = userSalesMap[a.id] ?? 0;
          final salesB = userSalesMap[b.id] ?? 0;
          return salesB.compareTo(salesA);
        });

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedUsers.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = sortedUsers[index];
            final sales = userSalesMap[user.id] ?? 0.0;
            final profit = userProfitMap[user.id] ?? 0.0;
            
            // Only show users with no stats if we really want to, but typically hide them or show 0
            // Showing all for transparency is fine too.
            // if (sales == 0 && profit == 0) return const SizedBox.shrink();

            // Generate consistent color based on user ID or name
            final colorIndex = user.id.hashCode.abs() % Colors.primaries.length;
            final userColor = Colors.primaries[colorIndex];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: userColor.withValues(alpha: 0.1),
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : '?', 
                  style: TextStyle(color: userColor, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(user.name),
              subtitle: Text('\$${sales.toStringAsFixed(2)} Sales • \$${profit.toStringAsFixed(2)} Profit'),
              trailing: IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.red),
                onPressed: () => _showResetConfirmation(context, ref, user),
                tooltip: 'Reset User Stats',
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text('Error loading users: $e'),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref, UserModel user) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Statistics?'),
        content: Text('Archive and reset stats for ${user.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await ref.read(historyServiceProvider).archiveAndResetStats(user);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _KPIItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KPIItem({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.mutedTextColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
