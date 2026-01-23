// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  bool get isFirstLogin => throw _privateConstructorUsedError;
  String? get currentShiftId => throw _privateConstructorUsedError;
  double get hourlyRate => throw _privateConstructorUsedError;
  double get baseSalary => throw _privateConstructorUsedError;
  SalaryType get salaryType => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    UserRole role,
    bool isFirstLogin,
    String? currentShiftId,
    double hourlyRate,
    double baseSalary,
    SalaryType salaryType,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? isFirstLogin = null,
    Object? currentShiftId = freezed,
    Object? hourlyRate = null,
    Object? baseSalary = null,
    Object? salaryType = null,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            isFirstLogin: null == isFirstLogin
                ? _value.isFirstLogin
                : isFirstLogin // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentShiftId: freezed == currentShiftId
                ? _value.currentShiftId
                : currentShiftId // ignore: cast_nullable_to_non_nullable
                      as String?,
            hourlyRate: null == hourlyRate
                ? _value.hourlyRate
                : hourlyRate // ignore: cast_nullable_to_non_nullable
                      as double,
            baseSalary: null == baseSalary
                ? _value.baseSalary
                : baseSalary // ignore: cast_nullable_to_non_nullable
                      as double,
            salaryType: null == salaryType
                ? _value.salaryType
                : salaryType // ignore: cast_nullable_to_non_nullable
                      as SalaryType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    UserRole role,
    bool isFirstLogin,
    String? currentShiftId,
    double hourlyRate,
    double baseSalary,
    SalaryType salaryType,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? isFirstLogin = null,
    Object? currentShiftId = freezed,
    Object? hourlyRate = null,
    Object? baseSalary = null,
    Object? salaryType = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        isFirstLogin: null == isFirstLogin
            ? _value.isFirstLogin
            : isFirstLogin // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentShiftId: freezed == currentShiftId
            ? _value.currentShiftId
            : currentShiftId // ignore: cast_nullable_to_non_nullable
                  as String?,
        hourlyRate: null == hourlyRate
            ? _value.hourlyRate
            : hourlyRate // ignore: cast_nullable_to_non_nullable
                  as double,
        baseSalary: null == baseSalary
            ? _value.baseSalary
            : baseSalary // ignore: cast_nullable_to_non_nullable
                  as double,
        salaryType: null == salaryType
            ? _value.salaryType
            : salaryType // ignore: cast_nullable_to_non_nullable
                  as SalaryType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isFirstLogin = true,
    this.currentShiftId,
    this.hourlyRate = 0.0,
    this.baseSalary = 0.0,
    this.salaryType = SalaryType.hourly,
  });

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final UserRole role;
  @override
  @JsonKey()
  final bool isFirstLogin;
  @override
  final String? currentShiftId;
  @override
  @JsonKey()
  final double hourlyRate;
  @override
  @JsonKey()
  final double baseSalary;
  @override
  @JsonKey()
  final SalaryType salaryType;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, isFirstLogin: $isFirstLogin, currentShiftId: $currentShiftId, hourlyRate: $hourlyRate, baseSalary: $baseSalary, salaryType: $salaryType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isFirstLogin, isFirstLogin) ||
                other.isFirstLogin == isFirstLogin) &&
            (identical(other.currentShiftId, currentShiftId) ||
                other.currentShiftId == currentShiftId) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.baseSalary, baseSalary) ||
                other.baseSalary == baseSalary) &&
            (identical(other.salaryType, salaryType) ||
                other.salaryType == salaryType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    role,
    isFirstLogin,
    currentShiftId,
    hourlyRate,
    baseSalary,
    salaryType,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String name,
    required final String email,
    required final UserRole role,
    final bool isFirstLogin,
    final String? currentShiftId,
    final double hourlyRate,
    final double baseSalary,
    final SalaryType salaryType,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  UserRole get role;
  @override
  bool get isFirstLogin;
  @override
  String? get currentShiftId;
  @override
  double get hourlyRate;
  @override
  double get baseSalary;
  @override
  SalaryType get salaryType;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
