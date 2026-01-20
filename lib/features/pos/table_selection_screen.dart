import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/table_model.dart';
import '../admin/tables/table_provider.dart';

class TableSelectionScreen extends ConsumerWidget {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Table')),
      body: tablesAsync.when(
        data: (tables) => _TableSelectionCanvas(tables: tables),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TableSelectionCanvas extends StatelessWidget {
  final List<TableModel> tables;

  const _TableSelectionCanvas({required this.tables});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.1,
      maxScale: 4.0,
      child: Container(
        width: 2500,
        height: 2500,
        color: Colors.grey.shade200,
        child: Stack(
          children: tables.map((table) => Positioned(
            left: table.x,
            top: table.y,
            child: GestureDetector(
              onTap: () => Navigator.pop(context, table),
              child: _ReadOnlyTableWidget(table: table),
            ),
          )).toList(),
        ),
      ),
    );
  }
}

class _ReadOnlyTableWidget extends StatelessWidget {
  final TableModel table;

  const _ReadOnlyTableWidget({required this.table});

  @override
  Widget build(BuildContext context) {
    final isOccupied = table.status == TableStatus.occupied;
    final color = isOccupied ? Colors.red.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.3);
    final borderColor = isOccupied ? Colors.red : Colors.green;

    return Container(
      width: table.width,
      height: table.height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: table.shape == TableShape.circle 
            ? BorderRadius.circular(table.width / 2) 
            : BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              table.name, 
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (isOccupied)
              const Icon(Icons.people, size: 16, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
