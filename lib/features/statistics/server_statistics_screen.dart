import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stats_provider.dart';
import 'widgets/stats_card.dart';
import '../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ServerStatisticsScreen extends ConsumerWidget {
  const ServerStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userDailyStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Statistics')),
      body: statsAsync.when(
        data: (stats) {
          if (stats.isEmpty) {
            return const Center(child: Text('No statistics recorded yet.'));
          }

          // Summary metrics (Current Day)
          final today = stats.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Performance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Sales',
                        value: '\$${today.sales.toStringAsFixed(2)}',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Tips',
                        value: '\$${today.tips.toStringAsFixed(2)}',
                        icon: Icons.redeem,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Orders',
                        value: '${today.orderCount}',
                        icon: Icons.receipt_long,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                const Text(
                  '7-Day History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = stats[index];
                      final date = DateFormat('EEEE, MMM d').format(item.date);
                      return ListTile(
                        title: Text(date),
                        subtitle: Text('${item.orderCount} orders'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${item.sales.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '+\$${item.tips.toStringAsFixed(2)} tips',
                              style: const TextStyle(fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
