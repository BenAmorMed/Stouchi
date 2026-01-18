import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/order_model.dart';
import 'pos_provider.dart';
import '../../services/order_service.dart';

final orderServiceProvider = Provider((ref) => OrderService());

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _tipController = TextEditingController();
  bool _isProcessing = false;

  void _completeOrder() async {
    setState(() => _isProcessing = true);
    try {
      final cart = ref.read(cartProvider);
      final tip = double.tryParse(_tipController.text) ?? 0.0;
      final finalOrder = cart.copyWith(
        tip: tip,
        status: OrderStatus.completed,
        timestamp: DateTime.now(),
      );

      await ref.read(orderServiceProvider).completeOrder(finalOrder);
      
      if (mounted) {
        ref.read(cartProvider.notifier).clear();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order completed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.articleName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              if (item.comments.isNotEmpty)
                                Text(
                                  item.comments.join(', '),
                                  style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                        Text('\$${item.price.toStringAsFixed(2)}'),
                      ],
                    );
                  },
                ),
              ),
              const Divider(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal', style: TextStyle(fontSize: 16)),
                  Text('\$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tip', style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _tipController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        prefixText: '\$',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(
                    '\$${(cart.total + (double.tryParse(_tipController.text) ?? 0.0)).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              if (_isProcessing)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: cart.items.isEmpty ? null : _completeOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 64),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('Complete Payment', style: TextStyle(fontSize: 18)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
