import 'package:flutter/material.dart';
import '../../../../core/models/table_model.dart';

class TableEditorDialog extends StatefulWidget {
  final TableModel? table; // Null if new

  const TableEditorDialog({super.key, this.table});

  @override
  State<TableEditorDialog> createState() => _TableEditorDialogState();
}

class _TableEditorDialogState extends State<TableEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late double _width;
  late double _height;
  late TableShape _shape;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.table?.name ?? 'T1');
    _width = widget.table?.width ?? 100;
    _height = widget.table?.height ?? 100;
    _shape = widget.table?.shape ?? TableShape.rectangle;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.table == null ? 'Add Table' : 'Edit Table'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Table Name'),
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _width.toString(),
                    decoration: const InputDecoration(labelText: 'Width'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _width = double.tryParse(val) ?? _width,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _height.toString(),
                    decoration: const InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _height = double.tryParse(val) ?? _height,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TableShape>(
              key: ValueKey(_shape),
              initialValue: _shape,
              decoration: const InputDecoration(labelText: 'Shape'),
              items: TableShape.values.map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.name.toUpperCase()),
              )).toList(),
              onChanged: (val) => setState(() => _shape = val!),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.table != null)
           TextButton(
             onPressed: () => Navigator.pop(context, 'DELETE'),
             style: TextButton.styleFrom(foregroundColor: Colors.red),
             child: const Text('Delete'),
           ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'name': _nameController.text,
                'width': _width,
                'height': _height,
                'shape': _shape,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
