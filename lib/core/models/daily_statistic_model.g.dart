// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_statistic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyStatisticModelImpl _$$DailyStatisticModelImplFromJson(
  Map<String, dynamic> json,
) => _$DailyStatisticModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
  tips: (json['tips'] as num?)?.toDouble() ?? 0.0,
  orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$DailyStatisticModelImplToJson(
  _$DailyStatisticModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': instance.date.toIso8601String(),
  'sales': instance.sales,
  'tips': instance.tips,
  'orderCount': instance.orderCount,
};
