// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salary_payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalaryPaymentModel _$SalaryPaymentModelFromJson(Map<String, dynamic> json) {
  return _SalaryPaymentModel.fromJson(json);
}

/// @nodoc
mixin _$SalaryPaymentModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get hoursWorked => throw _privateConstructorUsedError;
  DateTime get periodStart => throw _privateConstructorUsedError;
  DateTime get periodEnd => throw _privateConstructorUsedError;
  DateTime get paidAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this SalaryPaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalaryPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalaryPaymentModelCopyWith<SalaryPaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalaryPaymentModelCopyWith<$Res> {
  factory $SalaryPaymentModelCopyWith(
    SalaryPaymentModel value,
    $Res Function(SalaryPaymentModel) then,
  ) = _$SalaryPaymentModelCopyWithImpl<$Res, SalaryPaymentModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    double amount,
    double hoursWorked,
    DateTime periodStart,
    DateTime periodEnd,
    DateTime paidAt,
    String? notes,
  });
}

/// @nodoc
class _$SalaryPaymentModelCopyWithImpl<$Res, $Val extends SalaryPaymentModel>
    implements $SalaryPaymentModelCopyWith<$Res> {
  _$SalaryPaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalaryPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amount = null,
    Object? hoursWorked = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? paidAt = null,
    Object? notes = freezed,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            hoursWorked: null == hoursWorked
                ? _value.hoursWorked
                : hoursWorked // ignore: cast_nullable_to_non_nullable
                      as double,
            periodStart: null == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            periodEnd: null == periodEnd
                ? _value.periodEnd
                : periodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            paidAt: null == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalaryPaymentModelImplCopyWith<$Res>
    implements $SalaryPaymentModelCopyWith<$Res> {
  factory _$$SalaryPaymentModelImplCopyWith(
    _$SalaryPaymentModelImpl value,
    $Res Function(_$SalaryPaymentModelImpl) then,
  ) = __$$SalaryPaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    double amount,
    double hoursWorked,
    DateTime periodStart,
    DateTime periodEnd,
    DateTime paidAt,
    String? notes,
  });
}

/// @nodoc
class __$$SalaryPaymentModelImplCopyWithImpl<$Res>
    extends _$SalaryPaymentModelCopyWithImpl<$Res, _$SalaryPaymentModelImpl>
    implements _$$SalaryPaymentModelImplCopyWith<$Res> {
  __$$SalaryPaymentModelImplCopyWithImpl(
    _$SalaryPaymentModelImpl _value,
    $Res Function(_$SalaryPaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalaryPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amount = null,
    Object? hoursWorked = null,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? paidAt = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$SalaryPaymentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        hoursWorked: null == hoursWorked
            ? _value.hoursWorked
            : hoursWorked // ignore: cast_nullable_to_non_nullable
                  as double,
        periodStart: null == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodEnd: null == periodEnd
            ? _value.periodEnd
            : periodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        paidAt: null == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalaryPaymentModelImpl implements _SalaryPaymentModel {
  const _$SalaryPaymentModelImpl({
    required this.id,
    required this.userId,
    required this.amount,
    required this.hoursWorked,
    required this.periodStart,
    required this.periodEnd,
    required this.paidAt,
    this.notes,
  });

  factory _$SalaryPaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalaryPaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double amount;
  @override
  final double hoursWorked;
  @override
  final DateTime periodStart;
  @override
  final DateTime periodEnd;
  @override
  final DateTime paidAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SalaryPaymentModel(id: $id, userId: $userId, amount: $amount, hoursWorked: $hoursWorked, periodStart: $periodStart, periodEnd: $periodEnd, paidAt: $paidAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalaryPaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.hoursWorked, hoursWorked) ||
                other.hoursWorked == hoursWorked) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    amount,
    hoursWorked,
    periodStart,
    periodEnd,
    paidAt,
    notes,
  );

  /// Create a copy of SalaryPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalaryPaymentModelImplCopyWith<_$SalaryPaymentModelImpl> get copyWith =>
      __$$SalaryPaymentModelImplCopyWithImpl<_$SalaryPaymentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalaryPaymentModelImplToJson(this);
  }
}

abstract class _SalaryPaymentModel implements SalaryPaymentModel {
  const factory _SalaryPaymentModel({
    required final String id,
    required final String userId,
    required final double amount,
    required final double hoursWorked,
    required final DateTime periodStart,
    required final DateTime periodEnd,
    required final DateTime paidAt,
    final String? notes,
  }) = _$SalaryPaymentModelImpl;

  factory _SalaryPaymentModel.fromJson(Map<String, dynamic> json) =
      _$SalaryPaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double get amount;
  @override
  double get hoursWorked;
  @override
  DateTime get periodStart;
  @override
  DateTime get periodEnd;
  @override
  DateTime get paidAt;
  @override
  String? get notes;

  /// Create a copy of SalaryPaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalaryPaymentModelImplCopyWith<_$SalaryPaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
