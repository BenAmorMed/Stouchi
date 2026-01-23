// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FixedExpenseModelImpl _$$FixedExpenseModelImplFromJson(
  Map<String, dynamic> json,
) => _$FixedExpenseModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: (json['amount'] as num).toDouble(),
  frequency: $enumDecode(_$ExpenseFrequencyEnumMap, json['frequency']),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$FixedExpenseModelImplToJson(
  _$FixedExpenseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'amount': instance.amount,
  'frequency': _$ExpenseFrequencyEnumMap[instance.frequency]!,
  'isActive': instance.isActive,
};

const _$ExpenseFrequencyEnumMap = {
  ExpenseFrequency.monthly: 'monthly',
  ExpenseFrequency.yearly: 'yearly',
  ExpenseFrequency.semiannually: 'semiannually',
  ExpenseFrequency.oneTime: 'oneTime',
};
