// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleModelImpl _$$ArticleModelImplFromJson(Map<String, dynamic> json) =>
    _$ArticleModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      commentConfig: json['commentConfig'] == null
          ? const CommentConfig()
          : CommentConfig.fromJson(
              json['commentConfig'] as Map<String, dynamic>,
            ),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$ArticleModelImplToJson(_$ArticleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'categoryId': instance.categoryId,
      'commentConfig': instance.commentConfig,
      'imageUrl': instance.imageUrl,
    };
