// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_archive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryArchiveModelImpl _$$HistoryArchiveModelImplFromJson(
  Map<String, dynamic> json,
) => _$HistoryArchiveModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  date: DateTime.parse(json['date'] as String),
  totalSales: (json['totalSales'] as num).toDouble(),
  totalTips: (json['totalTips'] as num).toDouble(),
  orderCount: (json['orderCount'] as num).toInt(),
  archivedAt: DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$$HistoryArchiveModelImplToJson(
  _$HistoryArchiveModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'date': instance.date.toIso8601String(),
  'totalSales': instance.totalSales,
  'totalTips': instance.totalTips,
  'orderCount': instance.orderCount,
  'archivedAt': instance.archivedAt.toIso8601String(),
};
