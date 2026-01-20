// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockBatchImpl _$$StockBatchImplFromJson(Map<String, dynamic> json) =>
    _$StockBatchImpl(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      costPrice: (json['costPrice'] as num).toDouble(),
      dateAdded: DateTime.parse(json['dateAdded'] as String),
    );

Map<String, dynamic> _$$StockBatchImplToJson(_$StockBatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'costPrice': instance.costPrice,
      'dateAdded': instance.dateAdded.toIso8601String(),
    };
