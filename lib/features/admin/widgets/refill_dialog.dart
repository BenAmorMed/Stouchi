import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/stock_product_model.dart';
import '../../../core/models/stock_batch.dart';
import '../../../core/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class RefillDialog extends StatefulWidget {
  final StockProductModel product;

  const RefillDialog({super.key, required this.product});

  @override
  State<RefillDialog> createState() => _RefillDialogState();
}

class _RefillDialogState extends State<RefillDialog> {
  final _quantityController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _updateTotalCost() {
    final qty = double.tryParse(_quantityController.text) ?? 0;
    final unitCost = double.tryParse(_unitCostController.text) ?? 0;
    _totalCostController.text = (qty * unitCost).toStringAsFixed(2);
  }

  void _updateQuantity() {
    final unitCost = double.tryParse(_unitCostController.text) ?? 0;
    final totalCost = double.tryParse(_totalCostController.text) ?? 0;
    if (unitCost > 0) {
      _quantityController.text = (totalCost / unitCost).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    _totalCostController.dispose();
    super.dispose();
  }

  Future<void> _refill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final qty = double.parse(_quantityController.text);
      final unitCost = double.parse(_unitCostController.text);

      final newBatch = StockBatch(
        id: const Uuid().v4(),
        quantity: qty,
        costPrice: unitCost,
        dateAdded: DateTime.now(),
      );

      final updatedBatches = [...widget.product.batches, newBatch];
      final newTotalStock = widget.product.stockQuantity + qty;

      await FirebaseFirestore.instance
          .collection('stock_products')
          .doc(widget.product.id)
          .update({
        'batches': updatedBatches.map((b) => b.toJson()).toList(),
        'stockQuantity': newTotalStock,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refill successful! Stock added: $qty ${widget.product.unit.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceColor,
      title: Text('Refill ${widget.product.name}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Stock: ${widget.product.stockQuantity.toStringAsFixed(2)} ${widget.product.unit.name}',
                style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity to Add (${widget.product.unit.name})',
                  suffixText: widget.product.unit.name,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateTotalCost(),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final n = double.tryParse(val);
                  if (n == null || n <= 0) return 'Invalid quantity';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitCostController,
                decoration: const InputDecoration(
                  labelText: 'Unit Cost Price',
                  prefixText: '\$',
                  helperText: 'Price per single unit',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateTotalCost(),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final n = double.tryParse(val);
                  if (n == null || n < 0) return 'Invalid cost';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalCostController,
                decoration: const InputDecoration(
                  labelText: 'Total Cost Price',
                  prefixText: '\$',
                  helperText: 'Enter total or calculate from unit',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateQuantity(),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final n = double.tryParse(val);
                  if (n == null || n < 0) return 'Invalid cost';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _refill,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Confirm Refill'),
        ),
      ],
    );
  }
}
