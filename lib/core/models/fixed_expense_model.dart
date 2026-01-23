import 'package:freezed_annotation/freezed_annotation.dart';

part 'fixed_expense_model.freezed.dart';
part 'fixed_expense_model.g.dart';

enum ExpenseFrequency {
  monthly,
  yearly,
  semiannually,
  oneTime,
}

@freezed
class FixedExpenseModel with _$FixedExpenseModel {
  const factory FixedExpenseModel({
    required String id,
    required String name,
    required double amount,
    required ExpenseFrequency frequency,
    @Default(true) bool isActive,
  }) = _FixedExpenseModel;

  factory FixedExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$FixedExpenseModelFromJson(json);
}
