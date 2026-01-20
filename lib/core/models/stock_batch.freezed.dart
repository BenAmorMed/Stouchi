// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StockBatch _$StockBatchFromJson(Map<String, dynamic> json) {
  return _StockBatch.fromJson(json);
}

/// @nodoc
mixin _$StockBatch {
  String get id => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double get costPrice => throw _privateConstructorUsedError;
  DateTime get dateAdded => throw _privateConstructorUsedError;

  /// Serializes this StockBatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockBatchCopyWith<StockBatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockBatchCopyWith<$Res> {
  factory $StockBatchCopyWith(
    StockBatch value,
    $Res Function(StockBatch) then,
  ) = _$StockBatchCopyWithImpl<$Res, StockBatch>;
  @useResult
  $Res call({String id, double quantity, double costPrice, DateTime dateAdded});
}

/// @nodoc
class _$StockBatchCopyWithImpl<$Res, $Val extends StockBatch>
    implements $StockBatchCopyWith<$Res> {
  _$StockBatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? costPrice = null,
    Object? dateAdded = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            costPrice: null == costPrice
                ? _value.costPrice
                : costPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            dateAdded: null == dateAdded
                ? _value.dateAdded
                : dateAdded // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockBatchImplCopyWith<$Res>
    implements $StockBatchCopyWith<$Res> {
  factory _$$StockBatchImplCopyWith(
    _$StockBatchImpl value,
    $Res Function(_$StockBatchImpl) then,
  ) = __$$StockBatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, double quantity, double costPrice, DateTime dateAdded});
}

/// @nodoc
class __$$StockBatchImplCopyWithImpl<$Res>
    extends _$StockBatchCopyWithImpl<$Res, _$StockBatchImpl>
    implements _$$StockBatchImplCopyWith<$Res> {
  __$$StockBatchImplCopyWithImpl(
    _$StockBatchImpl _value,
    $Res Function(_$StockBatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? costPrice = null,
    Object? dateAdded = null,
  }) {
    return _then(
      _$StockBatchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        costPrice: null == costPrice
            ? _value.costPrice
            : costPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        dateAdded: null == dateAdded
            ? _value.dateAdded
            : dateAdded // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockBatchImpl implements _StockBatch {
  const _$StockBatchImpl({
    required this.id,
    required this.quantity,
    required this.costPrice,
    required this.dateAdded,
  });

  factory _$StockBatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockBatchImplFromJson(json);

  @override
  final String id;
  @override
  final double quantity;
  @override
  final double costPrice;
  @override
  final DateTime dateAdded;

  @override
  String toString() {
    return 'StockBatch(id: $id, quantity: $quantity, costPrice: $costPrice, dateAdded: $dateAdded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockBatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.costPrice, costPrice) ||
                other.costPrice == costPrice) &&
            (identical(other.dateAdded, dateAdded) ||
                other.dateAdded == dateAdded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quantity, costPrice, dateAdded);

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockBatchImplCopyWith<_$StockBatchImpl> get copyWith =>
      __$$StockBatchImplCopyWithImpl<_$StockBatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockBatchImplToJson(this);
  }
}

abstract class _StockBatch implements StockBatch {
  const factory _StockBatch({
    required final String id,
    required final double quantity,
    required final double costPrice,
    required final DateTime dateAdded,
  }) = _$StockBatchImpl;

  factory _StockBatch.fromJson(Map<String, dynamic> json) =
      _$StockBatchImpl.fromJson;

  @override
  String get id;
  @override
  double get quantity;
  @override
  double get costPrice;
  @override
  DateTime get dateAdded;

  /// Create a copy of StockBatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockBatchImplCopyWith<_$StockBatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
