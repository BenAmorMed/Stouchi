import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_payment_model.freezed.dart';
part 'salary_payment_model.g.dart';

@freezed
class SalaryPaymentModel with _$SalaryPaymentModel {
  const factory SalaryPaymentModel({
    required String id,
    required String userId,
    required double amount,
    required double hoursWorked,
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime paidAt,
    String? notes,
  }) = _SalaryPaymentModel;

  factory SalaryPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$SalaryPaymentModelFromJson(json);
}
