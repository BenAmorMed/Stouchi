import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus {
  pending,
  completed,
  cancelled,
}

@JsonSerializable(explicitToJson: true)
@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String userId,
    required List<OrderItemModel> items,
    required double total,
    @Default(0.0) double tip,
    @Default(OrderStatus.completed) OrderStatus status,
    required DateTime timestamp,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
