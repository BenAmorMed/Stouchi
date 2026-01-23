import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/user_model.dart';
import '../core/models/salary_payment_model.dart';
import '../core/models/time_entry_model.dart';

final salaryServiceProvider = Provider((ref) => SalaryService());

class SalaryService {
  final _db = FirebaseFirestore.instance;

  /// Calculates the salary and total hours for a user in a given period.
  Future<Map<String, dynamic>> calculatePendingSalary(UserModel user, DateTime start, DateTime end) async {
    final entriesSnapshot = await _db.collection('time_entries')
        .where('userId', isEqualTo: user.id)
        .where('clockIn', isGreaterThanOrEqualTo: start)
        .where('clockIn', isLessThanOrEqualTo: end)
        .get();

    double totalHours = 0;
    for (var doc in entriesSnapshot.docs) {
      final entry = TimeEntryModel.fromJson({...doc.data(), 'id': doc.id});
      if (entry.status == TimeEntryStatus.completed && entry.clockOut != null) {
        final duration = entry.clockOut!.difference(entry.clockIn);
        totalHours += duration.inMinutes / 60.0;
      }
    }

    double calculatedSalary = 0;
    switch (user.salaryType) {
      case SalaryType.hourly:
        calculatedSalary = totalHours * user.hourlyRate;
        break;
      case SalaryType.fixed:
        calculatedSalary = user.baseSalary;
        break;
      case SalaryType.both:
        calculatedSalary = user.baseSalary + (totalHours * user.hourlyRate);
        break;
    }

    return {
      'totalHours': totalHours,
      'calculatedSalary': calculatedSalary,
      'entryCount': entriesSnapshot.docs.length,
    };
  }

  /// Records a salary payment.
  Future<void> recordPayment(SalaryPaymentModel payment) async {
    await _db.collection('salary_payments').doc(payment.id).set(payment.toJson());
    
    // Optional: Record as a general expense for the financial report
    // We can add a "one-time expense" category or similar if needed.
  }

  /// Stream of all payments for a user.
  Stream<List<SalaryPaymentModel>> getPayments(String userId) {
    return _db.collection('salary_payments')
        .where('userId', isEqualTo: userId)
        .orderBy('paidAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SalaryPaymentModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }
}
