// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkScheduleImpl _$$WorkScheduleImplFromJson(Map<String, dynamic> json) =>
    _$WorkScheduleImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      date: const TimestampConverter().fromJson(json['date']),
      startTime: const TimestampConverter().fromJson(json['startTime']),
      endTime: const TimestampConverter().fromJson(json['endTime']),
      isFullDay: json['isFullDay'] as bool? ?? false,
      type:
          $enumDecodeNullable(_$ScheduleTypeEnumMap, json['type']) ??
          ScheduleType.shift,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$WorkScheduleImplToJson(_$WorkScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'date': const TimestampConverter().toJson(instance.date),
      'startTime': _$JsonConverterToJson<dynamic, DateTime>(
        instance.startTime,
        const TimestampConverter().toJson,
      ),
      'endTime': _$JsonConverterToJson<dynamic, DateTime>(
        instance.endTime,
        const TimestampConverter().toJson,
      ),
      'isFullDay': instance.isFullDay,
      'type': _$ScheduleTypeEnumMap[instance.type]!,
      'note': instance.note,
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.shift: 'shift',
  ScheduleType.off: 'off',
  ScheduleType.vacation: 'vacation',
  ScheduleType.sick: 'sick',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
