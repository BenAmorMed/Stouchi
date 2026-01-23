import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/models/daily_statistic_model.dart';

part 'hourly_statistic_model.freezed.dart';

@freezed
class HourlyStatistic with _$HourlyStatistic {
  const factory HourlyStatistic({
    required int hour, // 0-23
    @Default(0.0) double sales,
    @Default(0.0) double profit,
    @Default(0) int orderCount,
    @Default({}) Map<String, double> userSales, // UserId -> Sales
    @Default({}) Map<String, double> userProfit, // UserId -> Profit
    @Default({}) Map<String, ArticleDailyStats> articleStats,
  }) = _HourlyStatistic;
}
