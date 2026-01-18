import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_model.freezed.dart';
part 'shift_model.g.dart';

@freezed
class ShiftModel with _$ShiftModel {
  const factory ShiftModel({
    required String id,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0.0) double totalSales,
    @Default(0.0) double totalTips,
    @Default(0) int orderCount,
    @Default(true) bool isActive,
  }) = _ShiftModel;

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
}
