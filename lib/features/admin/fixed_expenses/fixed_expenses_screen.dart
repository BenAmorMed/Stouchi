import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/fixed_expense_model.dart';
import '../../../services/fixed_expenses_service.dart';
import '../../../core/theme/app_theme.dart';

class FixedExpensesScreen extends ConsumerWidget {
  const FixedExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(activeFixedExpensesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Fixed Expenses', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context, ref),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.money_off_rounded, size: 64, color: AppTheme.mutedTextColor.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('No fixed expenses yet.', style: TextStyle(color: AppTheme.mutedTextColor)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                elevation: 0,
                color: AppTheme.surfaceColor,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: AppTheme.primaryColor),
                  ),
                  title: Text(expense.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(
                    _getFrequencyLabel(expense.frequency),
                    style: const TextStyle(color: AppTheme.mutedTextColor),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showAddEditDialog(context, ref, expense: expense);
                          } else if (value == 'delete') {
                            _confirmDelete(context, ref, expense);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _getFrequencyLabel(ExpenseFrequency freq) {
    switch (freq) {
      case ExpenseFrequency.monthly: return 'Monthly';
      case ExpenseFrequency.yearly: return 'Yearly';
      case ExpenseFrequency.semiannually: return 'Every 6 Months';
      case ExpenseFrequency.oneTime: return 'One-Time / On Demand';
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, FixedExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: Text('Are you sure you want to delete "${expense.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(fixedExpensesServiceProvider).deleteExpense(expense.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, WidgetRef ref, {FixedExpenseModel? expense}) {
    final nameController = TextEditingController(text: expense?.name ?? '');
    final amountController = TextEditingController(text: expense?.amount.toString() ?? '');
    ExpenseFrequency selectedFrequency = expense?.frequency ?? ExpenseFrequency.monthly;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(expense == null ? 'Add Expense' : 'Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Expense Name', hintText: 'e.g., Rent'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount (\$)', hintText: '0.00'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Frequency'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ExpenseFrequency>(
                    value: selectedFrequency,
                    isDense: true,
                    items: ExpenseFrequency.values.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(_getFrequencyLabel(f)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedFrequency = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (name.isEmpty || amount <= 0) return;

                if (expense == null) {
                  ref.read(fixedExpensesServiceProvider).addExpense(
                    name: name,
                    amount: amount,
                    frequency: selectedFrequency,
                  );
                } else {
                  ref.read(fixedExpensesServiceProvider).updateExpense(
                    expense.copyWith(
                      name: name,
                      amount: amount,
                      frequency: selectedFrequency,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
