// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      tip: (json['tip'] as num?)?.toDouble() ?? 0.0,
      status:
          $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
          OrderStatus.pending,
      tableId: json['tableId'] as String?,
      tableName: json['tableName'] as String?,
      timestamp: const TimestampConverter().fromJson(json['timestamp']),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'tip': instance.tip,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'tableId': instance.tableId,
      'tableName': instance.tableName,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};
