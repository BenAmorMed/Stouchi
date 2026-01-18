import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String articleId,
    required String articleName,
    required double price,
    @Default(1) int quantity,
    @Default([]) List<String> comments,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}
