// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeIngredientImpl _$$RecipeIngredientImplFromJson(
  Map<String, dynamic> json,
) => _$RecipeIngredientImpl(
  id: _readId(json, 'id') as String,
  name: _readName(json, 'name') as String,
  quantity: (json['quantity'] as num).toDouble(),
  type:
      $enumDecodeNullable(_$IngredientTypeEnumMap, json['type']) ??
      IngredientType.stock,
);

Map<String, dynamic> _$$RecipeIngredientImplToJson(
  _$RecipeIngredientImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'quantity': instance.quantity,
  'type': _$IngredientTypeEnumMap[instance.type]!,
};

const _$IngredientTypeEnumMap = {
  IngredientType.stock: 'stock',
  IngredientType.article: 'article',
};
