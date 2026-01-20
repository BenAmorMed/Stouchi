// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeEntryModelImpl _$$TimeEntryModelImplFromJson(Map<String, dynamic> json) =>
    _$TimeEntryModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      clockIn: DateTime.parse(json['clockIn'] as String),
      clockOut: json['clockOut'] == null
          ? null
          : DateTime.parse(json['clockOut'] as String),
      status:
          $enumDecodeNullable(_$TimeEntryStatusEnumMap, json['status']) ??
          TimeEntryStatus.active,
      scheduleId: json['scheduleId'] as String?,
    );

Map<String, dynamic> _$$TimeEntryModelImplToJson(
  _$TimeEntryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'clockIn': instance.clockIn.toIso8601String(),
  'clockOut': instance.clockOut?.toIso8601String(),
  'status': _$TimeEntryStatusEnumMap[instance.status]!,
  'scheduleId': instance.scheduleId,
};

const _$TimeEntryStatusEnumMap = {
  TimeEntryStatus.active: 'active',
  TimeEntryStatus.completed: 'completed',
};
