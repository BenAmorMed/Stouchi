// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkSchedule _$WorkScheduleFromJson(Map<String, dynamic> json) {
  return _WorkSchedule.fromJson(json);
}

/// @nodoc
mixin _$WorkSchedule {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError; // Normalized to start of day
  @TimestampConverter()
  DateTime? get startTime => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get endTime => throw _privateConstructorUsedError;
  bool get isFullDay => throw _privateConstructorUsedError;
  ScheduleType get type => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this WorkSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkScheduleCopyWith<WorkSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkScheduleCopyWith<$Res> {
  factory $WorkScheduleCopyWith(
    WorkSchedule value,
    $Res Function(WorkSchedule) then,
  ) = _$WorkScheduleCopyWithImpl<$Res, WorkSchedule>;
  @useResult
  $Res call({
    String id,
    String userId,
    String userName,
    @TimestampConverter() DateTime date,
    @TimestampConverter() DateTime? startTime,
    @TimestampConverter() DateTime? endTime,
    bool isFullDay,
    ScheduleType type,
    String? note,
  });
}

/// @nodoc
class _$WorkScheduleCopyWithImpl<$Res, $Val extends WorkSchedule>
    implements $WorkScheduleCopyWith<$Res> {
  _$WorkScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? date = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? isFullDay = null,
    Object? type = null,
    Object? note = freezed,
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
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isFullDay: null == isFullDay
                ? _value.isFullDay
                : isFullDay // ignore: cast_nullable_to_non_nullable
                      as bool,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ScheduleType,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkScheduleImplCopyWith<$Res>
    implements $WorkScheduleCopyWith<$Res> {
  factory _$$WorkScheduleImplCopyWith(
    _$WorkScheduleImpl value,
    $Res Function(_$WorkScheduleImpl) then,
  ) = __$$WorkScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String userName,
    @TimestampConverter() DateTime date,
    @TimestampConverter() DateTime? startTime,
    @TimestampConverter() DateTime? endTime,
    bool isFullDay,
    ScheduleType type,
    String? note,
  });
}

/// @nodoc
class __$$WorkScheduleImplCopyWithImpl<$Res>
    extends _$WorkScheduleCopyWithImpl<$Res, _$WorkScheduleImpl>
    implements _$$WorkScheduleImplCopyWith<$Res> {
  __$$WorkScheduleImplCopyWithImpl(
    _$WorkScheduleImpl _value,
    $Res Function(_$WorkScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? date = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? isFullDay = null,
    Object? type = null,
    Object? note = freezed,
  }) {
    return _then(
      _$WorkScheduleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isFullDay: null == isFullDay
            ? _value.isFullDay
            : isFullDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ScheduleType,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkScheduleImpl implements _WorkSchedule {
  const _$WorkScheduleImpl({
    required this.id,
    required this.userId,
    required this.userName,
    @TimestampConverter() required this.date,
    @TimestampConverter() this.startTime,
    @TimestampConverter() this.endTime,
    this.isFullDay = false,
    this.type = ScheduleType.shift,
    this.note,
  });

  factory _$WorkScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  @TimestampConverter()
  final DateTime date;
  // Normalized to start of day
  @override
  @TimestampConverter()
  final DateTime? startTime;
  @override
  @TimestampConverter()
  final DateTime? endTime;
  @override
  @JsonKey()
  final bool isFullDay;
  @override
  @JsonKey()
  final ScheduleType type;
  @override
  final String? note;

  @override
  String toString() {
    return 'WorkSchedule(id: $id, userId: $userId, userName: $userName, date: $date, startTime: $startTime, endTime: $endTime, isFullDay: $isFullDay, type: $type, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isFullDay, isFullDay) ||
                other.isFullDay == isFullDay) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    userName,
    date,
    startTime,
    endTime,
    isFullDay,
    type,
    note,
  );

  /// Create a copy of WorkSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkScheduleImplCopyWith<_$WorkScheduleImpl> get copyWith =>
      __$$WorkScheduleImplCopyWithImpl<_$WorkScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkScheduleImplToJson(this);
  }
}

abstract class _WorkSchedule implements WorkSchedule {
  const factory _WorkSchedule({
    required final String id,
    required final String userId,
    required final String userName,
    @TimestampConverter() required final DateTime date,
    @TimestampConverter() final DateTime? startTime,
    @TimestampConverter() final DateTime? endTime,
    final bool isFullDay,
    final ScheduleType type,
    final String? note,
  }) = _$WorkScheduleImpl;

  factory _WorkSchedule.fromJson(Map<String, dynamic> json) =
      _$WorkScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  @TimestampConverter()
  DateTime get date; // Normalized to start of day
  @override
  @TimestampConverter()
  DateTime? get startTime;
  @override
  @TimestampConverter()
  DateTime? get endTime;
  @override
  bool get isFullDay;
  @override
  ScheduleType get type;
  @override
  String? get note;

  /// Create a copy of WorkSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkScheduleImplCopyWith<_$WorkScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
