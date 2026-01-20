// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StockProductModel _$StockProductModelFromJson(Map<String, dynamic> json) {
  return _StockProductModel.fromJson(json);
}

/// @nodoc
mixin _$StockProductModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ArticleUnit get unit => throw _privateConstructorUsedError;
  double get stockQuantity => throw _privateConstructorUsedError;
  double get alertThreshold => throw _privateConstructorUsedError;
  List<StockBatch> get batches => throw _privateConstructorUsedError;

  /// Serializes this StockProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockProductModelCopyWith<StockProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockProductModelCopyWith<$Res> {
  factory $StockProductModelCopyWith(
    StockProductModel value,
    $Res Function(StockProductModel) then,
  ) = _$StockProductModelCopyWithImpl<$Res, StockProductModel>;
  @useResult
  $Res call({
    String id,
    String name,
    ArticleUnit unit,
    double stockQuantity,
    double alertThreshold,
    List<StockBatch> batches,
  });
}

/// @nodoc
class _$StockProductModelCopyWithImpl<$Res, $Val extends StockProductModel>
    implements $StockProductModelCopyWith<$Res> {
  _$StockProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? unit = null,
    Object? stockQuantity = null,
    Object? alertThreshold = null,
    Object? batches = null,
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
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as ArticleUnit,
            stockQuantity: null == stockQuantity
                ? _value.stockQuantity
                : stockQuantity // ignore: cast_nullable_to_non_nullable
                      as double,
            alertThreshold: null == alertThreshold
                ? _value.alertThreshold
                : alertThreshold // ignore: cast_nullable_to_non_nullable
                      as double,
            batches: null == batches
                ? _value.batches
                : batches // ignore: cast_nullable_to_non_nullable
                      as List<StockBatch>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockProductModelImplCopyWith<$Res>
    implements $StockProductModelCopyWith<$Res> {
  factory _$$StockProductModelImplCopyWith(
    _$StockProductModelImpl value,
    $Res Function(_$StockProductModelImpl) then,
  ) = __$$StockProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    ArticleUnit unit,
    double stockQuantity,
    double alertThreshold,
    List<StockBatch> batches,
  });
}

/// @nodoc
class __$$StockProductModelImplCopyWithImpl<$Res>
    extends _$StockProductModelCopyWithImpl<$Res, _$StockProductModelImpl>
    implements _$$StockProductModelImplCopyWith<$Res> {
  __$$StockProductModelImplCopyWithImpl(
    _$StockProductModelImpl _value,
    $Res Function(_$StockProductModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? unit = null,
    Object? stockQuantity = null,
    Object? alertThreshold = null,
    Object? batches = null,
  }) {
    return _then(
      _$StockProductModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as ArticleUnit,
        stockQuantity: null == stockQuantity
            ? _value.stockQuantity
            : stockQuantity // ignore: cast_nullable_to_non_nullable
                  as double,
        alertThreshold: null == alertThreshold
            ? _value.alertThreshold
            : alertThreshold // ignore: cast_nullable_to_non_nullable
                  as double,
        batches: null == batches
            ? _value._batches
            : batches // ignore: cast_nullable_to_non_nullable
                  as List<StockBatch>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockProductModelImpl implements _StockProductModel {
  const _$StockProductModelImpl({
    required this.id,
    required this.name,
    this.unit = ArticleUnit.piece,
    this.stockQuantity = 0.0,
    this.alertThreshold = 5.0,
    final List<StockBatch> batches = const [],
  }) : _batches = batches;

  factory _$StockProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockProductModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final ArticleUnit unit;
  @override
  @JsonKey()
  final double stockQuantity;
  @override
  @JsonKey()
  final double alertThreshold;
  final List<StockBatch> _batches;
  @override
  @JsonKey()
  List<StockBatch> get batches {
    if (_batches is EqualUnmodifiableListView) return _batches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batches);
  }

  @override
  String toString() {
    return 'StockProductModel(id: $id, name: $name, unit: $unit, stockQuantity: $stockQuantity, alertThreshold: $alertThreshold, batches: $batches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.alertThreshold, alertThreshold) ||
                other.alertThreshold == alertThreshold) &&
            const DeepCollectionEquality().equals(other._batches, _batches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    unit,
    stockQuantity,
    alertThreshold,
    const DeepCollectionEquality().hash(_batches),
  );

  /// Create a copy of StockProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockProductModelImplCopyWith<_$StockProductModelImpl> get copyWith =>
      __$$StockProductModelImplCopyWithImpl<_$StockProductModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockProductModelImplToJson(this);
  }
}

abstract class _StockProductModel implements StockProductModel {
  const factory _StockProductModel({
    required final String id,
    required final String name,
    final ArticleUnit unit,
    final double stockQuantity,
    final double alertThreshold,
    final List<StockBatch> batches,
  }) = _$StockProductModelImpl;

  factory _StockProductModel.fromJson(Map<String, dynamic> json) =
      _$StockProductModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  ArticleUnit get unit;
  @override
  double get stockQuantity;
  @override
  double get alertThreshold;
  @override
  List<StockBatch> get batches;

  /// Create a copy of StockProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockProductModelImplCopyWith<_$StockProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
