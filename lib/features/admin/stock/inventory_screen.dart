import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/stock_product_model.dart';
import '../../../../core/models/article_model.dart'; // Keep for ArticleUnit enum
import '../../../../core/theme/app_theme.dart';
import '../widgets/refill_dialog.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _showOnlyLowStock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory (Stock)'),
        actions: [
          Row(
            children: [
              const Text('Low Stock Only', style: TextStyle(fontSize: 12)),
              Switch(
                value: _showOnlyLowStock,
                onChanged: (val) => setState(() => _showOnlyLowStock = val),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stock_products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          final products = <StockProductModel>[];
          
          for (var doc in docs) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              products.add(StockProductModel.fromJson({
                ...data,
                'id': doc.id,
              }));
            } catch (e) {
              debugPrint('Error parsing stock product ${doc.id}: $e');
              // Skip malformed products for now so the screen doesn't crash
            }
          }

          var filteredProducts = products;
          if (_showOnlyLowStock) {
            filteredProducts = products.where((p) => p.stockQuantity <= p.alertThreshold).toList();
          }

          if (filteredProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(_showOnlyLowStock ? 'No low stock alerts' : 'Inventory is empty', style: const TextStyle(color: Colors.grey)),
                  if (docs.isNotEmpty && products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Check console for parsing errors', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              final isLow = product.stockQuantity <= product.alertThreshold;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isLow ? Colors.red.withValues(alpha: 0.1) : AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      isLow ? Icons.warning_amber_rounded : Icons.inventory_2,
                      color: isLow ? Colors.red : AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Level: ${product.stockQuantity.toStringAsFixed(2)} ${product.unit.name} (Min: ${product.alertThreshold})',
                    style: TextStyle(color: isLow ? Colors.red : AppTheme.mutedTextColor),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compact Refill Button
                      IconButton(
                        tooltip: 'Refill Stock',
                        icon: Icon(Icons.add_circle, color: isLow ? Colors.red : AppTheme.primaryColor),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => RefillDialog(product: product),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _showAddEditDialog(context, product: product),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _confirmDelete(context, product),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        label: const Text('Add Stock Product'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {StockProductModel? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final thresholdController = TextEditingController(text: product?.alertThreshold.toString() ?? '5.0');
    final initialQtyController = TextEditingController(text: '0.0');
    final unitCostController = TextEditingController(text: '0.0');
    final totalCostController = TextEditingController(text: '0.0');
    ArticleUnit selectedUnit = product?.unit ?? ArticleUnit.piece;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          void updateTotalCost() {
            final qty = double.tryParse(initialQtyController.text) ?? 0;
            final unitCost = double.tryParse(unitCostController.text) ?? 0;
            totalCostController.text = (qty * unitCost).toStringAsFixed(2);
          }

          void updateQuantity() {
            final unitCost = double.tryParse(unitCostController.text) ?? 0;
            final totalCost = double.tryParse(totalCostController.text) ?? 0;
            if (unitCost > 0) {
              initialQtyController.text = (totalCost / unitCost).toStringAsFixed(2);
            }
          }

          return AlertDialog(
            title: Text(product == null ? 'New Stock Product' : 'Edit Stock Product'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name (e.g. Coffee Beans)'),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ArticleUnit>(
                      initialValue: selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: ArticleUnit.values.map((u) => DropdownMenuItem(
                        value: u,
                        child: Text(u.name.toUpperCase()),
                      )).toList(),
                      onChanged: (val) => setDialogState(() => selectedUnit = val!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: thresholdController,
                      decoration: const InputDecoration(labelText: 'Alert Threshold'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                    ),
                    if (product == null) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: initialQtyController,
                        decoration: const InputDecoration(labelText: 'Initial Quantity'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => updateTotalCost(),
                        validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: unitCostController,
                        decoration: const InputDecoration(labelText: 'Unit Cost Price', prefixText: '\$'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => updateTotalCost(),
                        validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: totalCostController,
                        decoration: const InputDecoration(labelText: 'Total Cost Price', prefixText: '\$'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => updateQuantity(),
                        validator: (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  
                  try {
                    final double threshold = double.parse(thresholdController.text);
                    final data = {
                      'name': nameController.text.trim(),
                      'unit': selectedUnit.name,
                      'alertThreshold': threshold,
                    };

                    if (product == null) {
                      final double qty = double.parse(initialQtyController.text);
                      final double unitPrice = double.parse(unitCostController.text);
                      
                      data['stockQuantity'] = qty;
                      if (qty > 0) {
                        data['batches'] = [{
                          'id': DateTime.now().millisecondsSinceEpoch.toString(),
                          'quantity': qty,
                          'costPrice': unitPrice,
                          'dateAdded': DateTime.now().toIso8601String(),
                        }];
                      } else {
                        data['batches'] = [];
                      }
                      await FirebaseFirestore.instance.collection('stock_products').add(data);
                    } else {
                      await FirebaseFirestore.instance.collection('stock_products').doc(product.id).update(data);
                    }
                    
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    debugPrint('Error saving stock product: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, StockProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Stock Product?'),
        content: Text('Are you sure you want to delete "${product.name}"? Articles using this product will no longer track stock correctly.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('stock_products').doc(product.id).delete();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
