import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stats_provider.dart';
import '../auth/auth_provider.dart';
import 'widgets/stats_card.dart';
import 'history_archive_screen.dart';
import '../../services/history_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_model.dart';

final historyServiceProvider = Provider((ref) => HistoryService());

class AdminStatisticsScreen extends ConsumerWidget {
  const AdminStatisticsScreen({super.key});

  void _showResetConfirmation(BuildContext context, WidgetRef ref, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Reset Statistics?'),
        content: Text('This will archive all current statistics for ${user.name} and reset their daily values to zero. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(historyServiceProvider).archiveAndResetStats(user);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Statistics archived for ${user.name}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset & Archive'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final statsAsync = ref.watch(adminAggregateStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Statistics'),
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
      body: statsAsync.when(
        data: (stats) {
          final totalSales = stats.fold(0.0, (sum, item) => sum + item.sales);
          final totalTips = stats.fold(0.0, (sum, item) => sum + item.tips);
          final totalOrders = stats.fold<int>(0, (sum, item) => sum + item.orderCount);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Global Performance (Live)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: StatsCard(
                          title: 'Total Sales',
                          value: '\$${totalSales.toStringAsFixed(2)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 140,
                        child: StatsCard(
                          title: 'Total Tips',
                          value: '\$${totalTips.toStringAsFixed(2)}',
                          icon: Icons.volunteer_activism_rounded,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 140,
                        child: StatsCard(
                          title: 'Total Orders',
                          value: '$totalOrders',
                          icon: Icons.shopping_basket_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'User Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                usersAsync.when(
                  data: (users) => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final userStats = stats.where((s) => s.userId == user.id).toList();
                      final userSales = userStats.fold(0.0, (sum, item) => sum + item.sales);
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                          child: Text(user.name[0], style: const TextStyle(color: AppTheme.primaryColor)),
                        ),
                        title: Text(user.name),
                        subtitle: Text('${userStats.length} active days • \$${userSales.toStringAsFixed(2)} sales'),
                        trailing: IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.red),
                          onPressed: () => _showResetConfirmation(context, ref, user),
                          tooltip: 'Reset User Stats',
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Error loading users: $e'),
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
