import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:uuid/uuid.dart';
import '../../../services/history_service.dart';
import '../../../services/fixed_expenses_service.dart';
import '../../../core/models/fixed_expense_model.dart';
import '../../../core/theme/app_theme.dart';

class HistoryResetDialog extends ConsumerStatefulWidget {
  const HistoryResetDialog({super.key});

  @override
  ConsumerState<HistoryResetDialog> createState() => _HistoryResetDialogState();
}

class _HistoryResetDialogState extends ConsumerState<HistoryResetDialog> {
  List<FixedExpenseModel> _pendedExpenses = [];
  bool _isLoading = true;
  String? _generatedReportPath;
  bool _canDelete = false;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      final expenses = await ref.read(activeFixedExpensesProvider.future);
      if (mounted) {
         setState(() {
           _pendedExpenses = List<FixedExpenseModel>.from(expenses);
           _isLoading = false;
         });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double get _totalDeduction => _pendedExpenses.fold(0.0, (sum, e) => sum + e.amount);

  void _addOneTimeExpense() {
    showDialog(
      context: context,
      builder: (context) {
        final nameCtrl = TextEditingController();
        final amountCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Add One-Time Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Repairs')),
              TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                if (nameCtrl.text.isNotEmpty && amount > 0) {
                  setState(() {
                    _pendedExpenses.add(FixedExpenseModel(
                      id: _uuid.v4(), 
                      name: nameCtrl.text, 
                      amount: amount, 
                      frequency: ExpenseFrequency.oneTime,
                      isActive: true
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _generateReport() async {
    setState(() => _isLoading = true);
    try {
      final path = await ref.read(historyServiceProvider).generateReport(expenses: _pendedExpenses);
      if (mounted) {
        setState(() {
          _generatedReportPath = path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _shareReport() async {
    if (_generatedReportPath == null) return;
    final result = await Share.shareXFiles([XFile(_generatedReportPath!)], text: 'Stouchi Financial Report');
    if (result.status == ShareResultStatus.success || result.status == ShareResultStatus.dismissed) {
      setState(() => _canDelete = true);
    }
  }

  void _printReport() async {
    setState(() => _isLoading = true);
    try {
      final bytes = await ref.read(historyServiceProvider).generatePdfReport(expenses: _pendedExpenses);
      
      await Printing.layoutPdf(
        onLayout: (format) async => bytes,
        name: 'Stouchi_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      
      setState(() {
        _isLoading = false;
        _canDelete = true; 
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print Error: $e')));
      }
    }
  }

  void _deleteHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PERMANENTLY DELETE HISTORY?', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will wipe all sales, orders, and statistics from the database.\n\n'
          'Ensure you have verified the report.\n\n'
          'Type "DELETE" to confirm (Simulated for now, just press Yes).',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('YES, DELETE EVERYTHING'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(historyServiceProvider).performHardReset();
        if (mounted) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History Reset Successfully')));
        }
      } catch (e) {
        if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.history_rounded, size: 28, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text('Reset History & Report', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 32),
            
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Deduct Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('One-Time'),
                            onPressed: _addOneTimeExpense,
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.separated(
                          itemCount: _pendedExpenses.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final exp = _pendedExpenses[index];
                            return ListTile(
                              dense: true,
                              title: Text(exp.name),
                              subtitle: Text(exp.frequency.name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('-\$${exp.amount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.red)),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 16),
                                    onPressed: () => setState(() => _pendedExpenses.removeAt(index)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Total Deduction: -\$${_totalDeduction.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      if (_generatedReportPath == null) ...[
                          FilledButton.icon(
                            onPressed: _generateReport,
                            icon: const Icon(Icons.receipt_long),
                            label: const Text('Generate Report'),
                            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                          ),
                      ] else ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: const Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('Report Generated!')]),
                          ),
                          const SizedBox(height: 12),
                          // SHARE TXT
                          FilledButton.icon(
                             onPressed: _shareReport,
                             icon: const Icon(Icons.textsms_outlined), // Changed icon to distinguish
                             label: const Text('Share Text Report'),
                             style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: Colors.blueGrey),
                          ),
                          const SizedBox(height: 12),
                          // PRINT / DOWNLOAD PDF
                          FilledButton.icon(
                             onPressed: _printReport,
                             icon: const Icon(Icons.print),
                             label: const Text('Print / Download PDF'),
                             style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: Colors.indigo),
                          ),
                          const SizedBox(height: 12),
                          
                          if (_canDelete)
                             OutlinedButton.icon(
                               onPressed: _deleteHistory,
                               icon: const Icon(Icons.delete_forever),
                               label: const Text('DELETE ALL HISTORY'),
                               style: OutlinedButton.styleFrom(
                                 minimumSize: const Size.fromHeight(48),
                                 foregroundColor: Colors.red,
                                 side: const BorderSide(color: Colors.red),
                               ),
                             )
                          else
                             const Text('Please share/save the report to unlock deletion.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ],
                  ),
            ),
            
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
