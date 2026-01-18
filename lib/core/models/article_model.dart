import 'package:freezed_annotation/freezed_annotation.dart';
import 'comment_config.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@JsonSerializable(explicitToJson: true)
@freezed
class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    required String id,
    required String name,
    required double price,
    required String categoryId,
    @Default(CommentConfig()) CommentConfig commentConfig,
    String? imageUrl,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}
