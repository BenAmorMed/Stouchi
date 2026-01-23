// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalaryPaymentModelImpl _$$SalaryPaymentModelImplFromJson(
  Map<String, dynamic> json,
) => _$SalaryPaymentModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  amount: (json['amount'] as num).toDouble(),
  hoursWorked: (json['hoursWorked'] as num).toDouble(),
  periodStart: DateTime.parse(json['periodStart'] as String),
  periodEnd: DateTime.parse(json['periodEnd'] as String),
  paidAt: DateTime.parse(json['paidAt'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$SalaryPaymentModelImplToJson(
  _$SalaryPaymentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'amount': instance.amount,
  'hoursWorked': instance.hoursWorked,
  'periodStart': instance.periodStart.toIso8601String(),
  'periodEnd': instance.periodEnd.toIso8601String(),
  'paidAt': instance.paidAt.toIso8601String(),
  'notes': instance.notes,
};
