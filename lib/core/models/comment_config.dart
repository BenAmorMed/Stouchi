import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_config.freezed.dart';
part 'comment_config.g.dart';

enum CommentType {
  list,
  text,
  both,
}

@freezed
class CommentConfig with _$CommentConfig {
  const factory CommentConfig({
    @Default(false) bool hasComments,
    @Default(CommentType.list) CommentType commentType,
    @Default([]) List<String> commentOptions,
    @Default('normal') String defaultOption,
    @Default(50) int maxLength,
  }) = _CommentConfig;

  factory CommentConfig.fromJson(Map<String, dynamic> json) =>
      _$CommentConfigFromJson(json);
}
