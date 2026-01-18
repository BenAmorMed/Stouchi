import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_archive_model.freezed.dart';
part 'history_archive_model.g.dart';

@freezed
class HistoryArchiveModel with _$HistoryArchiveModel {
  const factory HistoryArchiveModel({
    required String id,
    required String userId,
    required String userName,
    required DateTime date,
    required double totalSales,
    required double totalTips,
    required int orderCount,
    required DateTime archivedAt,
  }) = _HistoryArchiveModel;

  factory HistoryArchiveModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryArchiveModelFromJson(json);
}
