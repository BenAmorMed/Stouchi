import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/timestamp_converter.dart';

part 'daily_statistic_model.freezed.dart';
part 'daily_statistic_model.g.dart';

@freezed
class ArticleDailyStats with _$ArticleDailyStats {
  const factory ArticleDailyStats({
    required String name,
    @Default(0.0) double qty,
    @Default(0.0) double revenue,
    @Default(0.0) double profit,
  }) = _ArticleDailyStats;

  factory ArticleDailyStats.fromJson(Map<String, dynamic> json) =>
      _$ArticleDailyStatsFromJson(json);
}

@freezed
class DailyStatisticModel with _$DailyStatisticModel {
  const factory DailyStatisticModel({
    required String id,
    required String userId,
    @TimestampConverter() required DateTime date,
    @Default(0.0) double sales,
    @Default(0.0) double tips,
    @Default(0.0) double profit,
    @Default(0) int orderCount,
    @Default({}) Map<String, ArticleDailyStats> articleStats,
  }) = _DailyStatisticModel;

  factory DailyStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$DailyStatisticModelFromJson(json);
}
