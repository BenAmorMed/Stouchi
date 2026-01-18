// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommentConfig _$CommentConfigFromJson(Map<String, dynamic> json) {
  return _CommentConfig.fromJson(json);
}

/// @nodoc
mixin _$CommentConfig {
  bool get hasComments => throw _privateConstructorUsedError;
  CommentType get commentType => throw _privateConstructorUsedError;
  List<String> get commentOptions => throw _privateConstructorUsedError;
  String get defaultOption => throw _privateConstructorUsedError;
  int get maxLength => throw _privateConstructorUsedError;

  /// Serializes this CommentConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentConfigCopyWith<CommentConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentConfigCopyWith<$Res> {
  factory $CommentConfigCopyWith(
    CommentConfig value,
    $Res Function(CommentConfig) then,
  ) = _$CommentConfigCopyWithImpl<$Res, CommentConfig>;
  @useResult
  $Res call({
    bool hasComments,
    CommentType commentType,
    List<String> commentOptions,
    String defaultOption,
    int maxLength,
  });
}

/// @nodoc
class _$CommentConfigCopyWithImpl<$Res, $Val extends CommentConfig>
    implements $CommentConfigCopyWith<$Res> {
  _$CommentConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasComments = null,
    Object? commentType = null,
    Object? commentOptions = null,
    Object? defaultOption = null,
    Object? maxLength = null,
  }) {
    return _then(
      _value.copyWith(
            hasComments: null == hasComments
                ? _value.hasComments
                : hasComments // ignore: cast_nullable_to_non_nullable
                      as bool,
            commentType: null == commentType
                ? _value.commentType
                : commentType // ignore: cast_nullable_to_non_nullable
                      as CommentType,
            commentOptions: null == commentOptions
                ? _value.commentOptions
                : commentOptions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            defaultOption: null == defaultOption
                ? _value.defaultOption
                : defaultOption // ignore: cast_nullable_to_non_nullable
                      as String,
            maxLength: null == maxLength
                ? _value.maxLength
                : maxLength // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommentConfigImplCopyWith<$Res>
    implements $CommentConfigCopyWith<$Res> {
  factory _$$CommentConfigImplCopyWith(
    _$CommentConfigImpl value,
    $Res Function(_$CommentConfigImpl) then,
  ) = __$$CommentConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool hasComments,
    CommentType commentType,
    List<String> commentOptions,
    String defaultOption,
    int maxLength,
  });
}

/// @nodoc
class __$$CommentConfigImplCopyWithImpl<$Res>
    extends _$CommentConfigCopyWithImpl<$Res, _$CommentConfigImpl>
    implements _$$CommentConfigImplCopyWith<$Res> {
  __$$CommentConfigImplCopyWithImpl(
    _$CommentConfigImpl _value,
    $Res Function(_$CommentConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasComments = null,
    Object? commentType = null,
    Object? commentOptions = null,
    Object? defaultOption = null,
    Object? maxLength = null,
  }) {
    return _then(
      _$CommentConfigImpl(
        hasComments: null == hasComments
            ? _value.hasComments
            : hasComments // ignore: cast_nullable_to_non_nullable
                  as bool,
        commentType: null == commentType
            ? _value.commentType
            : commentType // ignore: cast_nullable_to_non_nullable
                  as CommentType,
        commentOptions: null == commentOptions
            ? _value._commentOptions
            : commentOptions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        defaultOption: null == defaultOption
            ? _value.defaultOption
            : defaultOption // ignore: cast_nullable_to_non_nullable
                  as String,
        maxLength: null == maxLength
            ? _value.maxLength
            : maxLength // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentConfigImpl implements _CommentConfig {
  const _$CommentConfigImpl({
    this.hasComments = false,
    this.commentType = CommentType.list,
    final List<String> commentOptions = const [],
    this.defaultOption = 'normal',
    this.maxLength = 50,
  }) : _commentOptions = commentOptions;

  factory _$CommentConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentConfigImplFromJson(json);

  @override
  @JsonKey()
  final bool hasComments;
  @override
  @JsonKey()
  final CommentType commentType;
  final List<String> _commentOptions;
  @override
  @JsonKey()
  List<String> get commentOptions {
    if (_commentOptions is EqualUnmodifiableListView) return _commentOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commentOptions);
  }

  @override
  @JsonKey()
  final String defaultOption;
  @override
  @JsonKey()
  final int maxLength;

  @override
  String toString() {
    return 'CommentConfig(hasComments: $hasComments, commentType: $commentType, commentOptions: $commentOptions, defaultOption: $defaultOption, maxLength: $maxLength)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentConfigImpl &&
            (identical(other.hasComments, hasComments) ||
                other.hasComments == hasComments) &&
            (identical(other.commentType, commentType) ||
                other.commentType == commentType) &&
            const DeepCollectionEquality().equals(
              other._commentOptions,
              _commentOptions,
            ) &&
            (identical(other.defaultOption, defaultOption) ||
                other.defaultOption == defaultOption) &&
            (identical(other.maxLength, maxLength) ||
                other.maxLength == maxLength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hasComments,
    commentType,
    const DeepCollectionEquality().hash(_commentOptions),
    defaultOption,
    maxLength,
  );

  /// Create a copy of CommentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentConfigImplCopyWith<_$CommentConfigImpl> get copyWith =>
      __$$CommentConfigImplCopyWithImpl<_$CommentConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentConfigImplToJson(this);
  }
}

abstract class _CommentConfig implements CommentConfig {
  const factory _CommentConfig({
    final bool hasComments,
    final CommentType commentType,
    final List<String> commentOptions,
    final String defaultOption,
    final int maxLength,
  }) = _$CommentConfigImpl;

  factory _CommentConfig.fromJson(Map<String, dynamic> json) =
      _$CommentConfigImpl.fromJson;

  @override
  bool get hasComments;
  @override
  CommentType get commentType;
  @override
  List<String> get commentOptions;
  @override
  String get defaultOption;
  @override
  int get maxLength;

  /// Create a copy of CommentConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentConfigImplCopyWith<_$CommentConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
