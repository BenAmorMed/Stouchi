// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentConfigImpl _$$CommentConfigImplFromJson(Map<String, dynamic> json) =>
    _$CommentConfigImpl(
      hasComments: json['hasComments'] as bool? ?? false,
      commentType:
          $enumDecodeNullable(_$CommentTypeEnumMap, json['commentType']) ??
          CommentType.list,
      commentOptions:
          (json['commentOptions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      defaultOption: json['defaultOption'] as String? ?? 'normal',
      maxLength: (json['maxLength'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$$CommentConfigImplToJson(_$CommentConfigImpl instance) =>
    <String, dynamic>{
      'hasComments': instance.hasComments,
      'commentType': _$CommentTypeEnumMap[instance.commentType]!,
      'commentOptions': instance.commentOptions,
      'defaultOption': instance.defaultOption,
      'maxLength': instance.maxLength,
    };

const _$CommentTypeEnumMap = {
  CommentType.list: 'list',
  CommentType.text: 'text',
  CommentType.both: 'both',
};
