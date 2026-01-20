import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_entry_model.freezed.dart';
part 'time_entry_model.g.dart';

enum TimeEntryStatus { active, completed }

@freezed
class TimeEntryModel with _$TimeEntryModel {
  const factory TimeEntryModel({
    required String id,
    required String userId,
    required DateTime clockIn,
    DateTime? clockOut,
    @Default(TimeEntryStatus.active) TimeEntryStatus status,
    String? scheduleId, // Optional link to planned schedule
  }) = _TimeEntryModel;

  factory TimeEntryModel.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryModelFromJson(json);
}
