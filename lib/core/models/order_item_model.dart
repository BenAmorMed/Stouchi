import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String articleId,
    required String articleName,
    required double price,
    @Default(1.0) double quantity, // Changed from int to double
    @Default(0.0) double costPrice, // For profit calculation (FIFO based)
    @Default([]) List<String> comments, // Global comments applied to all units
    @Default({}) Map<int, List<String>> perUnitComments, // Per-unit comments (unit index -> comments)
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}
