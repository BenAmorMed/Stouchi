import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/timestamp_converter.dart';

part 'work_schedule_model.freezed.dart';
part 'work_schedule_model.g.dart';

enum ScheduleType { shift, off, vacation, sick }

@freezed
class WorkSchedule with _$WorkSchedule {
  const factory WorkSchedule({
    required String id,
    required String userId,
    required String userName,
    @TimestampConverter() required DateTime date, // Normalized to start of day
    @TimestampConverter() DateTime? startTime,
    @TimestampConverter() DateTime? endTime,
    @Default(false) bool isFullDay,
    @Default(ScheduleType.shift) ScheduleType type,
    String? note,
  }) = _WorkSchedule;

  factory WorkSchedule.fromJson(Map<String, dynamic> json) =>
      _$WorkScheduleFromJson(json);
}
