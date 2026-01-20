// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeEntryModel _$TimeEntryModelFromJson(Map<String, dynamic> json) {
  return _TimeEntryModel.fromJson(json);
}

/// @nodoc
mixin _$TimeEntryModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get clockIn => throw _privateConstructorUsedError;
  DateTime? get clockOut => throw _privateConstructorUsedError;
  TimeEntryStatus get status => throw _privateConstructorUsedError;
  String? get scheduleId => throw _privateConstructorUsedError;

  /// Serializes this TimeEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeEntryModelCopyWith<TimeEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeEntryModelCopyWith<$Res> {
  factory $TimeEntryModelCopyWith(
    TimeEntryModel value,
    $Res Function(TimeEntryModel) then,
  ) = _$TimeEntryModelCopyWithImpl<$Res, TimeEntryModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime clockIn,
    DateTime? clockOut,
    TimeEntryStatus status,
    String? scheduleId,
  });
}

/// @nodoc
class _$TimeEntryModelCopyWithImpl<$Res, $Val extends TimeEntryModel>
    implements $TimeEntryModelCopyWith<$Res> {
  _$TimeEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? clockIn = null,
    Object? clockOut = freezed,
    Object? status = null,
    Object? scheduleId = freezed,
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
            clockIn: null == clockIn
                ? _value.clockIn
                : clockIn // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            clockOut: freezed == clockOut
                ? _value.clockOut
                : clockOut // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TimeEntryStatus,
            scheduleId: freezed == scheduleId
                ? _value.scheduleId
                : scheduleId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeEntryModelImplCopyWith<$Res>
    implements $TimeEntryModelCopyWith<$Res> {
  factory _$$TimeEntryModelImplCopyWith(
    _$TimeEntryModelImpl value,
    $Res Function(_$TimeEntryModelImpl) then,
  ) = __$$TimeEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime clockIn,
    DateTime? clockOut,
    TimeEntryStatus status,
    String? scheduleId,
  });
}

/// @nodoc
class __$$TimeEntryModelImplCopyWithImpl<$Res>
    extends _$TimeEntryModelCopyWithImpl<$Res, _$TimeEntryModelImpl>
    implements _$$TimeEntryModelImplCopyWith<$Res> {
  __$$TimeEntryModelImplCopyWithImpl(
    _$TimeEntryModelImpl _value,
    $Res Function(_$TimeEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? clockIn = null,
    Object? clockOut = freezed,
    Object? status = null,
    Object? scheduleId = freezed,
  }) {
    return _then(
      _$TimeEntryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        clockIn: null == clockIn
            ? _value.clockIn
            : clockIn // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        clockOut: freezed == clockOut
            ? _value.clockOut
            : clockOut // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TimeEntryStatus,
        scheduleId: freezed == scheduleId
            ? _value.scheduleId
            : scheduleId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeEntryModelImpl implements _TimeEntryModel {
  const _$TimeEntryModelImpl({
    required this.id,
    required this.userId,
    required this.clockIn,
    this.clockOut,
    this.status = TimeEntryStatus.active,
    this.scheduleId,
  });

  factory _$TimeEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeEntryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime clockIn;
  @override
  final DateTime? clockOut;
  @override
  @JsonKey()
  final TimeEntryStatus status;
  @override
  final String? scheduleId;

  @override
  String toString() {
    return 'TimeEntryModel(id: $id, userId: $userId, clockIn: $clockIn, clockOut: $clockOut, status: $status, scheduleId: $scheduleId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeEntryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.clockIn, clockIn) || other.clockIn == clockIn) &&
            (identical(other.clockOut, clockOut) ||
                other.clockOut == clockOut) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    clockIn,
    clockOut,
    status,
    scheduleId,
  );

  /// Create a copy of TimeEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeEntryModelImplCopyWith<_$TimeEntryModelImpl> get copyWith =>
      __$$TimeEntryModelImplCopyWithImpl<_$TimeEntryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeEntryModelImplToJson(this);
  }
}

abstract class _TimeEntryModel implements TimeEntryModel {
  const factory _TimeEntryModel({
    required final String id,
    required final String userId,
    required final DateTime clockIn,
    final DateTime? clockOut,
    final TimeEntryStatus status,
    final String? scheduleId,
  }) = _$TimeEntryModelImpl;

  factory _TimeEntryModel.fromJson(Map<String, dynamic> json) =
      _$TimeEntryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get clockIn;
  @override
  DateTime? get clockOut;
  @override
  TimeEntryStatus get status;
  @override
  String? get scheduleId;

  /// Create a copy of TimeEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeEntryModelImplCopyWith<_$TimeEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
