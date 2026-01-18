import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/order_model.dart';
import '../../core/models/user_role.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';
import 'pos_provider.dart';

class LiveOrdersScreen extends ConsumerWidget {
  const LiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProfileProvider).value;
    final isAdmin = currentUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tables / Open Orders'),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: isAdmin
            ? FirebaseFirestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'pending')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'pending')
                .where('userId', isEqualTo: currentUser?.id ?? '')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs
              .map((doc) => OrderModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
              .toList();

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant_rounded, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text('No open tables right now.', style: TextStyle(color: Colors.white54)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.75, // Ensure no overflow with extra vertical space
            ),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final duration = DateTime.now().difference(order.timestamp).inMinutes;

              return InkWell(
                onTap: () {
                  ref.read(cartProvider.notifier).loadOrder(order);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(12), // Reduced from 16
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              order.tableName ?? 'Unknown',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${duration}m',
                              style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${order.items.length} items',
                        style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 13),
                      ),
                      const SizedBox(height: 2), // Reduced from 4
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
