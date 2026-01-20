import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/work_schedule_model.dart';
import '../admin_calendar_screen.dart';

class ShiftDialog extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const ShiftDialog({super.key, required this.selectedDate});

  @override
  ConsumerState<ShiftDialog> createState() => _ShiftDialogState();
}

class _ShiftDialogState extends ConsumerState<ShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _userNames = {};
  bool _isSaving = false;
  String? _selectedUserId;
  String? _selectedUserName;
  ScheduleType _type = ScheduleType.shift;
  bool _isFullDay = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Shift'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Selector
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final users = snapshot.data!.docs;
                  
                  // Update map of names
                  for (var doc in users) {
                    final data = doc.data() as Map<String, dynamic>;
                    _userNames[doc.id] = data['name'] ?? 'Unknown';
                  }
                  
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Employee'),
                    items: users.map((doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(_userNames[doc.id]!),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedUserId = val;
                        _selectedUserName = _userNames[val];
                      });
                    },
                    validator: (val) => val == null ? 'Required' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Date Display
              Text('Date: ${widget.selectedDate.toString().split(' ')[0]}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Type Selector
              DropdownButtonFormField<ScheduleType>(
                key: ValueKey(_type),
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ScheduleType.values.map((t) => DropdownMenuItem(
                  value: t, 
                  child: Text(t.name.toUpperCase())
                )).toList(),
                onChanged: (val) => setState(() => _type = val!),
              ),
              const SizedBox(height: 16),
              
              // Full Day Switch
              SwitchListTile(
                title: const Text('Full Day / No Time'),
                value: _isFullDay,
                onChanged: (val) => setState(() => _isFullDay = val),
              ),

              if (!_isFullDay) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: _startTime);
                          if (t != null) setState(() => _startTime = t);
                        },
                        child: Text('Start: ${_startTime.format(context)}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: _endTime);
                          if (t != null) setState(() => _endTime = t);
                        },
                        child: Text('End: ${_endTime.format(context)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: (_isSaving || _selectedUserId == null) ? null : _save,
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUserId == null || _selectedUserName == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final start = DateTime(
        widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day,
        _startTime.hour, _startTime.minute
      );
      
      final end = DateTime(
        widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day,
        _endTime.hour, _endTime.minute
      );

      final schedule = WorkSchedule(
        id: const Uuid().v4(),
        userId: _selectedUserId!,
        userName: _selectedUserName!,
        date: widget.selectedDate,
        type: _type,
        isFullDay: _isFullDay,
        startTime: _isFullDay ? null : start,
        endTime: _isFullDay ? null : end,
      );

      await ref.read(scheduleServiceProvider).addSchedule(schedule);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving shift: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
