// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return _RecipeIngredient.fromJson(json);
}

/// @nodoc
mixin _$RecipeIngredient {
  @JsonKey(readValue: _readId)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readName)
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  IngredientType get type => throw _privateConstructorUsedError;

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeIngredientCopyWith<RecipeIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeIngredientCopyWith<$Res> {
  factory $RecipeIngredientCopyWith(
    RecipeIngredient value,
    $Res Function(RecipeIngredient) then,
  ) = _$RecipeIngredientCopyWithImpl<$Res, RecipeIngredient>;
  @useResult
  $Res call({
    @JsonKey(readValue: _readId) String id,
    @JsonKey(readValue: _readName) String name,
    double quantity,
    IngredientType type,
  });
}

/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res, $Val extends RecipeIngredient>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as IngredientType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecipeIngredientImplCopyWith<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  factory _$$RecipeIngredientImplCopyWith(
    _$RecipeIngredientImpl value,
    $Res Function(_$RecipeIngredientImpl) then,
  ) = __$$RecipeIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(readValue: _readId) String id,
    @JsonKey(readValue: _readName) String name,
    double quantity,
    IngredientType type,
  });
}

/// @nodoc
class __$$RecipeIngredientImplCopyWithImpl<$Res>
    extends _$RecipeIngredientCopyWithImpl<$Res, _$RecipeIngredientImpl>
    implements _$$RecipeIngredientImplCopyWith<$Res> {
  __$$RecipeIngredientImplCopyWithImpl(
    _$RecipeIngredientImpl _value,
    $Res Function(_$RecipeIngredientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? type = null,
  }) {
    return _then(
      _$RecipeIngredientImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as IngredientType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeIngredientImpl implements _RecipeIngredient {
  const _$RecipeIngredientImpl({
    @JsonKey(readValue: _readId) required this.id,
    @JsonKey(readValue: _readName) required this.name,
    required this.quantity,
    this.type = IngredientType.stock,
  });

  factory _$RecipeIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeIngredientImplFromJson(json);

  @override
  @JsonKey(readValue: _readId)
  final String id;
  @override
  @JsonKey(readValue: _readName)
  final String name;
  @override
  final double quantity;
  @override
  @JsonKey()
  final IngredientType type;

  @override
  String toString() {
    return 'RecipeIngredient(id: $id, name: $name, quantity: $quantity, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeIngredientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, type);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      __$$RecipeIngredientImplCopyWithImpl<_$RecipeIngredientImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeIngredientImplToJson(this);
  }
}

abstract class _RecipeIngredient implements RecipeIngredient {
  const factory _RecipeIngredient({
    @JsonKey(readValue: _readId) required final String id,
    @JsonKey(readValue: _readName) required final String name,
    required final double quantity,
    final IngredientType type,
  }) = _$RecipeIngredientImpl;

  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) =
      _$RecipeIngredientImpl.fromJson;

  @override
  @JsonKey(readValue: _readId)
  String get id;
  @override
  @JsonKey(readValue: _readName)
  String get name;
  @override
  double get quantity;
  @override
  IngredientType get type;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
