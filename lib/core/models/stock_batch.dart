import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_batch.freezed.dart';
part 'stock_batch.g.dart';

@freezed
class StockBatch with _$StockBatch {
  const factory StockBatch({
    required String id,
    required double quantity,
    required double costPrice,
    required DateTime dateAdded,
  }) = _StockBatch;

  factory StockBatch.fromJson(Map<String, dynamic> json) =>
      _$StockBatchFromJson(json);
}
