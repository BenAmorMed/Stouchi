// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FixedExpenseModel _$FixedExpenseModelFromJson(Map<String, dynamic> json) {
  return _FixedExpenseModel.fromJson(json);
}

/// @nodoc
mixin _$FixedExpenseModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  ExpenseFrequency get frequency => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this FixedExpenseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixedExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixedExpenseModelCopyWith<FixedExpenseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixedExpenseModelCopyWith<$Res> {
  factory $FixedExpenseModelCopyWith(
    FixedExpenseModel value,
    $Res Function(FixedExpenseModel) then,
  ) = _$FixedExpenseModelCopyWithImpl<$Res, FixedExpenseModel>;
  @useResult
  $Res call({
    String id,
    String name,
    double amount,
    ExpenseFrequency frequency,
    bool isActive,
  });
}

/// @nodoc
class _$FixedExpenseModelCopyWithImpl<$Res, $Val extends FixedExpenseModel>
    implements $FixedExpenseModelCopyWith<$Res> {
  _$FixedExpenseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixedExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? frequency = null,
    Object? isActive = null,
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
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as ExpenseFrequency,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FixedExpenseModelImplCopyWith<$Res>
    implements $FixedExpenseModelCopyWith<$Res> {
  factory _$$FixedExpenseModelImplCopyWith(
    _$FixedExpenseModelImpl value,
    $Res Function(_$FixedExpenseModelImpl) then,
  ) = __$$FixedExpenseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double amount,
    ExpenseFrequency frequency,
    bool isActive,
  });
}

/// @nodoc
class __$$FixedExpenseModelImplCopyWithImpl<$Res>
    extends _$FixedExpenseModelCopyWithImpl<$Res, _$FixedExpenseModelImpl>
    implements _$$FixedExpenseModelImplCopyWith<$Res> {
  __$$FixedExpenseModelImplCopyWithImpl(
    _$FixedExpenseModelImpl _value,
    $Res Function(_$FixedExpenseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixedExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? frequency = null,
    Object? isActive = null,
  }) {
    return _then(
      _$FixedExpenseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as ExpenseFrequency,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FixedExpenseModelImpl implements _FixedExpenseModel {
  const _$FixedExpenseModelImpl({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    this.isActive = true,
  });

  factory _$FixedExpenseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixedExpenseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double amount;
  @override
  final ExpenseFrequency frequency;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'FixedExpenseModel(id: $id, name: $name, amount: $amount, frequency: $frequency, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixedExpenseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, amount, frequency, isActive);

  /// Create a copy of FixedExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixedExpenseModelImplCopyWith<_$FixedExpenseModelImpl> get copyWith =>
      __$$FixedExpenseModelImplCopyWithImpl<_$FixedExpenseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FixedExpenseModelImplToJson(this);
  }
}

abstract class _FixedExpenseModel implements FixedExpenseModel {
  const factory _FixedExpenseModel({
    required final String id,
    required final String name,
    required final double amount,
    required final ExpenseFrequency frequency,
    final bool isActive,
  }) = _$FixedExpenseModelImpl;

  factory _FixedExpenseModel.fromJson(Map<String, dynamic> json) =
      _$FixedExpenseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get amount;
  @override
  ExpenseFrequency get frequency;
  @override
  bool get isActive;

  /// Create a copy of FixedExpenseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixedExpenseModelImplCopyWith<_$FixedExpenseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
