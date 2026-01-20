// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_statistic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleDailyStatsImpl _$$ArticleDailyStatsImplFromJson(
  Map<String, dynamic> json,
) => _$ArticleDailyStatsImpl(
  name: json['name'] as String,
  qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
  revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
  profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$ArticleDailyStatsImplToJson(
  _$ArticleDailyStatsImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'qty': instance.qty,
  'revenue': instance.revenue,
  'profit': instance.profit,
};

_$DailyStatisticModelImpl _$$DailyStatisticModelImplFromJson(
  Map<String, dynamic> json,
) => _$DailyStatisticModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: const TimestampConverter().fromJson(json['date']),
  sales: (json['sales'] as num?)?.toDouble() ?? 0.0,
  tips: (json['tips'] as num?)?.toDouble() ?? 0.0,
  profit: (json['profit'] as num?)?.toDouble() ?? 0.0,
  orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
  articleStats:
      (json['articleStats'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ArticleDailyStats.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
);

Map<String, dynamic> _$$DailyStatisticModelImplToJson(
  _$DailyStatisticModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'date': const TimestampConverter().toJson(instance.date),
  'sales': instance.sales,
  'tips': instance.tips,
  'profit': instance.profit,
  'orderCount': instance.orderCount,
  'articleStats': instance.articleStats.map((k, e) => MapEntry(k, e.toJson())),
};
