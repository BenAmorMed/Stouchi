import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/table_service.dart';
import '../../../../core/models/table_model.dart';

final tableServiceProvider = Provider((ref) => TableService());

final tablesStreamProvider = StreamProvider<List<TableModel>>((ref) {
  final service = ref.watch(tableServiceProvider);
  return service.getTables();
});
