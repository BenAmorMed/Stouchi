import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_statistic_model.freezed.dart';
part 'daily_statistic_model.g.dart';

@freezed
class DailyStatisticModel with _$DailyStatisticModel {
  const factory DailyStatisticModel({
    required String id,
    required String userId,
    required DateTime date,
    @Default(0.0) double sales,
    @Default(0.0) double tips,
    @Default(0) int orderCount,
  }) = _DailyStatisticModel;

  factory DailyStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$DailyStatisticModelFromJson(json);
}
