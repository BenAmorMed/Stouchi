import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/table_model.dart';
import 'table_provider.dart';
import 'widgets/table_editor_dialog.dart';

class TableLayoutScreen extends ConsumerWidget {
  const TableLayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Layout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Table',
            onPressed: () => _addTable(context, ref),
          ),
        ],
      ),
      body: tablesAsync.when(
        data: (tables) => _TableCanvas(tables: tables),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _addTable(BuildContext context, WidgetRef ref) async {
    final result = await showDialog(
      context: context,
      builder: (_) => const TableEditorDialog(),
    );

    if (result is Map) {
      final table = TableModel(
        id: const Uuid().v4(),
        name: result['name'],
        x: 100,
        y: 100,
        width: result['width'],
        height: result['height'],
        shape: result['shape'],
      );
      await ref.read(tableServiceProvider).saveTable(table);
    }
  }
}

class _TableCanvas extends ConsumerStatefulWidget {
  final List<TableModel> tables;

  const _TableCanvas({required this.tables});

  @override
  ConsumerState<_TableCanvas> createState() => _TableCanvasState();
}

class _TableCanvasState extends ConsumerState<_TableCanvas> {
  static const double _canvasSize = 2500.0;
  final Map<String, Offset> _dragOffsets = {};
  String? _draggingTableId;

  @override
  void didUpdateWidget(_TableCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cleanup offsets if stream data matches local drag (meaning save completed)
    // Or simpler: if we are not dragging, trust the stream.
    // If stream updates, we should probably clear the offset for that table to avoid staleness.
    if (_draggingTableId == null) {
       // Ideally we check if the new position is close to our local offset
       // For now, clear all offsets to ensure we sync with server.
       // This might cause a jump if server hasn't updated yet.
       // A better way is to clear offset ONLY if server position changed.
       // But 'tables' is a new list every time.
       // Let's NOT clear automatically to prevent jump-back.
       // We only clear on drag start? No.
       
       // Correct approach for flicker-free:
       // When saving, we update local state.
       // When stream update comes, if it matches local state, we remove local override.
       
       for (var table in widget.tables) {
         if (_dragOffsets.containsKey(table.id)) {
           final local = _dragOffsets[table.id]!;
           if ((local.dx - table.x).abs() < 1 && (local.dy - table.y).abs() < 1) {
             // Server caught up
             _dragOffsets.remove(table.id);
           }
         }
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.1,
      maxScale: 4.0,
      child: Container(
        width: _canvasSize,
        height: _canvasSize,
        color: Colors.grey.shade200,
        child: Stack(
          children: [
             Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
            
            ...widget.tables.map((table) {
              final isDragging = _draggingTableId == table.id;
              // Use local offset if available, otherwise server pos
              final currentOffset = _dragOffsets[table.id] ?? Offset(table.x, table.y);
              
              return Positioned(
                left: currentOffset.dx,
                top: currentOffset.dy,
                child: GestureDetector(
                  onPanStart: (_) => setState(() {
                    _draggingTableId = table.id;
                    _dragOffsets[table.id] = Offset(table.x, table.y);
                  }),
                  onPanUpdate: (details) {
                    setState(() {
                      final curr = _dragOffsets[table.id] ?? Offset(table.x, table.y);
                      _dragOffsets[table.id] = curr + details.delta;
                    });
                  },
                  onPanEnd: (_) async {
                    setState(() => _draggingTableId = null); // Stop dragging mode
                    
                    final finalPos = _dragOffsets[table.id]!;
                    // Snap to grid (10px)
                    final snappedX = (finalPos.dx / 10).round() * 10.0;
                    final snappedY = (finalPos.dy / 10).round() * 10.0;
                    
                    // Update local offset to snapped
                     setState(() {
                      _dragOffsets[table.id] = Offset(snappedX, snappedY);
                    });

                    await ref.read(tableServiceProvider).saveTable(table.copyWith(
                      x: snappedX, 
                      y: snappedY
                    ));
                  },
                  onTap: () => _editTable(context, ref, table),
                  child: _TableWidget(
                      table: table, 
                      isHovered: isDragging, // Use dragging as hover state
                      status: table.status
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _editTable(BuildContext context, WidgetRef ref, TableModel table) async {
    final result = await showDialog(
      context: context,
      builder: (_) => TableEditorDialog(table: table),
    );

    if (result == 'DELETE') {
      await ref.read(tableServiceProvider).deleteTable(table.id);
    } else if (result is Map) {
      final updated = table.copyWith(
        name: result['name'],
        width: result['width'],
        height: result['height'],
        shape: result['shape'],
      );
      await ref.read(tableServiceProvider).saveTable(updated);
    }
  }
}

class _TableWidget extends StatelessWidget {
  final TableModel table;
  final bool isHovered;
  final TableStatus status;

  const _TableWidget({
    required this.table,
    required this.isHovered,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == TableStatus.occupied ? Colors.red.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.3);
    final borderColor = status == TableStatus.occupied ? Colors.red : Colors.green;

    return Container(
      width: table.width,
      height: table.height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: isHovered ? Colors.blue : borderColor, width: 2),
        borderRadius: table.shape == TableShape.circle 
            ? BorderRadius.circular(table.width / 2) 
            : BorderRadius.circular(8),
        boxShadow: isHovered ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10)] : null,
      ),
      child: Center(
        child: Text(
          table.name, 
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withValues(alpha: 0.3);
    const step = 50.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
