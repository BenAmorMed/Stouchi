import 'package:freezed_annotation/freezed_annotation.dart';
import 'comment_config.dart';
import 'recipe_ingredient.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

enum ArticleUnit {
  piece,
  kg,
  liter,
}

@freezed
class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    required String id,
    required String name,
    required double price,
    required String categoryId,
    @Default(CommentConfig()) CommentConfig commentConfig,
    String? imageUrl,
    @Default(0.0) double totalProfit, // Lifetime profit from sales
    @Default(false) bool isComposite, // true if it has multiple ingredients
    @Default([]) List<RecipeIngredient> recipe, // Ingredients (even for 1:1 items)
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}
