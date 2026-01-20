// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockProductModelImpl _$$StockProductModelImplFromJson(
  Map<String, dynamic> json,
) => _$StockProductModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  unit:
      $enumDecodeNullable(_$ArticleUnitEnumMap, json['unit']) ??
      ArticleUnit.piece,
  stockQuantity: (json['stockQuantity'] as num?)?.toDouble() ?? 0.0,
  alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 5.0,
  batches:
      (json['batches'] as List<dynamic>?)
          ?.map((e) => StockBatch.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$StockProductModelImplToJson(
  _$StockProductModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'unit': _$ArticleUnitEnumMap[instance.unit]!,
  'stockQuantity': instance.stockQuantity,
  'alertThreshold': instance.alertThreshold,
  'batches': instance.batches.map((e) => e.toJson()).toList(),
};

const _$ArticleUnitEnumMap = {
  ArticleUnit.piece: 'piece',
  ArticleUnit.kg: 'kg',
  ArticleUnit.liter: 'liter',
};
