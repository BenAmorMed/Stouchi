import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/fixed_expense_model.dart';
import 'package:uuid/uuid.dart';

final fixedExpensesServiceProvider = Provider<FixedExpensesService>((ref) {
  return FixedExpensesService();
});

final activeFixedExpensesProvider = StreamProvider<List<FixedExpenseModel>>((ref) {
  final service = ref.watch(fixedExpensesServiceProvider);
  return service.getActiveExpenses();
});

class FixedExpensesService {
  final _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('fixed_expenses');

  // Fetch all active expenses
  Stream<List<FixedExpenseModel>> getActiveExpenses() {
    return _collection
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FixedExpenseModel.fromJson(doc.data()))
            .toList());
  }

  // Add new expense
  Future<void> addExpense({
    required String name,
    required double amount,
    required ExpenseFrequency frequency,
  }) async {
    final id = _uuid.v4();
    final expense = FixedExpenseModel(
      id: id,
      name: name,
      amount: amount,
      frequency: frequency,
      isActive: true,
    );
    await _collection.doc(id).set(expense.toJson());
  }

  // Edit expense
  Future<void> updateExpense(FixedExpenseModel expense) async {
    await _collection.doc(expense.id).set(expense.toJson());
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    await _collection.doc(id).delete();
  }
}
