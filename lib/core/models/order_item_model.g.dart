// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      articleId: json['articleId'] as String,
      articleName: json['articleName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      perUnitComments:
          (json['perUnitComments'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              int.parse(k),
              (e as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  'articleId': instance.articleId,
  'articleName': instance.articleName,
  'price': instance.price,
  'quantity': instance.quantity,
  'costPrice': instance.costPrice,
  'comments': instance.comments,
  'perUnitComments': instance.perUnitComments.map(
    (k, e) => MapEntry(k.toString(), e),
  ),
};
