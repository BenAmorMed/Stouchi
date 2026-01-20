import 'package:freezed_annotation/freezed_annotation.dart';
import 'article_model.dart';
import 'stock_batch.dart';

part 'stock_product_model.freezed.dart';
part 'stock_product_model.g.dart';

@freezed
class StockProductModel with _$StockProductModel {
  const factory StockProductModel({
    required String id,
    required String name,
    @Default(ArticleUnit.piece) ArticleUnit unit,
    @Default(0.0) double stockQuantity,
    @Default(5.0) double alertThreshold,
    @Default([]) List<StockBatch> batches,
  }) = _StockProductModel;

  factory StockProductModel.fromJson(Map<String, dynamic> json) =>
      _$StockProductModelFromJson(json);
}
