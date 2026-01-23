import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/user_role.dart';
import '../../../core/models/salary_payment_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/auth_provider.dart';
import '../../../services/salary_service.dart';

class SalaryManagementScreen extends ConsumerStatefulWidget {
  const SalaryManagementScreen({super.key});

  @override
  ConsumerState<SalaryManagementScreen> createState() => _SalaryManagementScreenState();
}

class _SalaryManagementScreenState extends ConsumerState<SalaryManagementScreen> {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();
  final _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Salaries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _DateRangeHeader(start: _startDate, end: _endDate, onTap: () => _selectDateRange(context)),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                final workers = users.where((u) => u.role != UserRole.admin).toList();
                if (workers.isEmpty) {
                  return const Center(child: Text('No workers found'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: workers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _WorkerSalaryCard(
                    user: workers[index],
                    start: _startDate,
                    end: _endDate,
                    onPay: (amount, hours) => _processPayment(workers[index], amount, hours),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _processPayment(UserModel user, double amount, double hours) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Payment for ${user.name}'),
        content: Text('Payout amount: \$${amount.toStringAsFixed(2)}\nHours tracked: ${hours.toStringAsFixed(1)}h'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirm Payment')),
        ],
      ),
    );

    if (confirm == true) {
      final payment = SalaryPaymentModel(
        id: _uuid.v4(),
        userId: user.id,
        amount: amount,
        hoursWorked: hours,
        periodStart: _startDate,
        periodEnd: _endDate,
        paidAt: DateTime.now(),
      );

      await ref.read(salaryServiceProvider).recordPayment(payment);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment recorded for ${user.name}')),
        );
      }
    }
  }
}

class _DateRangeHeader extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final VoidCallback onTap;

  const _DateRangeHeader({required this.start, required this.end, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM dd, yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: AppTheme.mutedTextColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PAYROLL PERIOD', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppTheme.mutedTextColor)),
                const SizedBox(height: 4),
                Text('${fmt.format(start)} - ${fmt.format(end)}', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.edit_calendar_rounded, size: 18),
            label: const Text('Change'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerSalaryCard extends ConsumerWidget {
  final UserModel user;
  final DateTime start;
  final DateTime end;
  final Function(double, double) onPay;

  const _WorkerSalaryCard({
    required this.user,
    required this.start,
    required this.end,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(salaryServiceProvider).calculatePendingSalary(user, start, end),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final data = snapshot.data!;
        final hours = data['totalHours'] as double;
        final salary = data['calculatedSalary'] as double;
        final entryCount = data['entryCount'] as int;

        return Card(
          elevation: 0,
          color: AppTheme.surfaceColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: AppTheme.mutedTextColor.withValues(alpha: 0.1)),
          ),
          child: InkWell(
            onTap: () {}, // Future: Link to user details or time entries
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user.salaryType.name.toUpperCase(),
                                style: const TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currencyFmt.format(salary),
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                          Text(
                            '${hours.toStringAsFixed(1)}h worked',
                            style: const TextStyle(color: AppTheme.mutedTextColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history_rounded, size: 16, color: AppTheme.mutedTextColor.withValues(alpha: 0.7)),
                          const SizedBox(width: 6),
                          Text(
                            '$entryCount shifts recorded',
                            style: const TextStyle(fontSize: 12, color: AppTheme.mutedTextColor),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: salary > 0 ? () => onPay(salary, hours) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          minimumSize: Size.zero,
                          elevation: salary > 0 ? 4 : 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.payment_rounded, size: 18),
                            const SizedBox(width: 10),
                            Text('PAY ${currencyFmt.format(salary)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
