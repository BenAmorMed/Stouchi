import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_ingredient.freezed.dart';
part 'recipe_ingredient.g.dart';

enum IngredientType {
  stock,
  article,
}

Object? _readId(Map json, String key) => json['id'] ?? json['stockProductId'];
Object? _readName(Map json, String key) => json['name'] ?? json['stockProductName'];

@freezed
class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    @JsonKey(readValue: _readId) required String id,
    @JsonKey(readValue: _readName) required String name,
    required double quantity,
    @Default(IngredientType.stock) IngredientType type,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}
