// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_statistic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyStatisticModel _$DailyStatisticModelFromJson(Map<String, dynamic> json) {
  return _DailyStatisticModel.fromJson(json);
}

/// @nodoc
mixin _$DailyStatisticModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  double get sales => throw _privateConstructorUsedError;
  double get tips => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;

  /// Serializes this DailyStatisticModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyStatisticModelCopyWith<DailyStatisticModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyStatisticModelCopyWith<$Res> {
  factory $DailyStatisticModelCopyWith(
    DailyStatisticModel value,
    $Res Function(DailyStatisticModel) then,
  ) = _$DailyStatisticModelCopyWithImpl<$Res, DailyStatisticModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    @TimestampConverter() DateTime date,
    double sales,
    double tips,
    int orderCount,
  });
}

/// @nodoc
class _$DailyStatisticModelCopyWithImpl<$Res, $Val extends DailyStatisticModel>
    implements $DailyStatisticModelCopyWith<$Res> {
  _$DailyStatisticModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? sales = null,
    Object? tips = null,
    Object? orderCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sales: null == sales
                ? _value.sales
                : sales // ignore: cast_nullable_to_non_nullable
                      as double,
            tips: null == tips
                ? _value.tips
                : tips // ignore: cast_nullable_to_non_nullable
                      as double,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyStatisticModelImplCopyWith<$Res>
    implements $DailyStatisticModelCopyWith<$Res> {
  factory _$$DailyStatisticModelImplCopyWith(
    _$DailyStatisticModelImpl value,
    $Res Function(_$DailyStatisticModelImpl) then,
  ) = __$$DailyStatisticModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    @TimestampConverter() DateTime date,
    double sales,
    double tips,
    int orderCount,
  });
}

/// @nodoc
class __$$DailyStatisticModelImplCopyWithImpl<$Res>
    extends _$DailyStatisticModelCopyWithImpl<$Res, _$DailyStatisticModelImpl>
    implements _$$DailyStatisticModelImplCopyWith<$Res> {
  __$$DailyStatisticModelImplCopyWithImpl(
    _$DailyStatisticModelImpl _value,
    $Res Function(_$DailyStatisticModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? sales = null,
    Object? tips = null,
    Object? orderCount = null,
  }) {
    return _then(
      _$DailyStatisticModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sales: null == sales
            ? _value.sales
            : sales // ignore: cast_nullable_to_non_nullable
                  as double,
        tips: null == tips
            ? _value.tips
            : tips // ignore: cast_nullable_to_non_nullable
                  as double,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyStatisticModelImpl implements _DailyStatisticModel {
  const _$DailyStatisticModelImpl({
    required this.id,
    required this.userId,
    @TimestampConverter() required this.date,
    this.sales = 0.0,
    this.tips = 0.0,
    this.orderCount = 0,
  });

  factory _$DailyStatisticModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyStatisticModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  @JsonKey()
  final double sales;
  @override
  @JsonKey()
  final double tips;
  @override
  @JsonKey()
  final int orderCount;

  @override
  String toString() {
    return 'DailyStatisticModel(id: $id, userId: $userId, date: $date, sales: $sales, tips: $tips, orderCount: $orderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyStatisticModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.sales, sales) || other.sales == sales) &&
            (identical(other.tips, tips) || other.tips == tips) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, date, sales, tips, orderCount);

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyStatisticModelImplCopyWith<_$DailyStatisticModelImpl> get copyWith =>
      __$$DailyStatisticModelImplCopyWithImpl<_$DailyStatisticModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyStatisticModelImplToJson(this);
  }
}

abstract class _DailyStatisticModel implements DailyStatisticModel {
  const factory _DailyStatisticModel({
    required final String id,
    required final String userId,
    @TimestampConverter() required final DateTime date,
    final double sales,
    final double tips,
    final int orderCount,
  }) = _$DailyStatisticModelImpl;

  factory _DailyStatisticModel.fromJson(Map<String, dynamic> json) =
      _$DailyStatisticModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  double get sales;
  @override
  double get tips;
  @override
  int get orderCount;

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyStatisticModelImplCopyWith<_$DailyStatisticModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
