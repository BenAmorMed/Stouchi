import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/timestamp_converter.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus {
  pending,
  completed,
  cancelled,
}

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String userId,
    required List<OrderItemModel> items,
    required double total,
    @Default(0.0) double tip,
    @Default(OrderStatus.pending) OrderStatus status,
    String? tableId,
    String? tableName,
    @TimestampConverter() required DateTime timestamp,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
