import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/work_schedule_model.dart';
import '../../../../services/schedule_service.dart';
import 'widgets/shift_dialog.dart';

final scheduleServiceProvider = Provider((ref) => ScheduleService());

final monthSchedulesProvider = StreamProvider.family<List<WorkSchedule>, DateTime>((ref, month) {
  return ref.watch(scheduleServiceProvider).getSchedulesForMonth(month);
});

class AdminCalendarScreen extends ConsumerStatefulWidget {
  const AdminCalendarScreen({super.key});

  @override
  ConsumerState<AdminCalendarScreen> createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends ConsumerState<AdminCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(monthSchedulesProvider(_focusedDay));

    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      appBar: AppBar(title: const Text('Worker Schedule')),
      body: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        children: [
          // Calendar View
          Expanded(
            flex: isMobile ? 0 : 2,
            child: Card(
              margin: const EdgeInsets.all(8),
              child: schedulesAsync.when(
                data: (schedules) {
                  return TableCalendar<WorkSchedule>(
                    firstDay: DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                       setState(() => _focusedDay = focusedDay);
                    },
                    eventLoader: (day) {
                      return schedules.where((s) => isSameDay(s.date, day)).toList();
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      headerPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                      cellPadding: EdgeInsets.all(4),
                    ),
                    rowHeight: isMobile ? 45 : 52,
                  );
                },
                loading: () => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
                error: (e, s) => SizedBox(height: 300, child: Center(child: Text('Error: $e'))),
              ),
            ),
          ),
          
          // Day Details View
          Expanded(
            flex: 1,
            child: Container(
              color: AppTheme.surfaceColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDay == null ? 'Select a day' : 'Shifts for ${_formatDate(_selectedDay!)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedDay != null)
                     Expanded(
                       child: ref.watch(monthSchedulesProvider(_focusedDay)).when(
                         data: (schedules) {
                           final daySchedules = schedules.where((s) => isSameDay(s.date, _selectedDay)).toList();
                           if (daySchedules.isEmpty) return const Text('No shifts scheduled.', style: TextStyle(color: Colors.grey));
                           
                           return ListView.builder(
                             itemCount: daySchedules.length,
                             itemBuilder: (context, index) {
                               final schedule = daySchedules[index];
                               return Card(
                                 child: ListTile(
                                   leading: CircleAvatar(child: Text(schedule.userName[0])),
                                   title: Text(schedule.userName),
                                   subtitle: Text(schedule.isFullDay 
                                     ? schedule.type.name.toUpperCase() 
                                     : '${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}'),
                                   trailing: IconButton(
                                     icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                     onPressed: () => ref.read(scheduleServiceProvider).deleteSchedule(schedule.id),
                                   ),
                                 ),
                               );
                             },
                           );
                         },
                         loading: () => const SizedBox(),
                         error: (_,__) => const SizedBox(),
                       ),
                     ),
                  
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _selectedDay == null ? null : () => _showAddShiftDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Shift'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.hour}:${dt.minute.toString().padLeft(2,'0')}';
  }

  void _showAddShiftDialog(BuildContext context) {
    if (_selectedDay == null) return;
    
    showDialog(
      context: context,
      builder: (context) => ShiftDialog(selectedDate: _selectedDay!),
    );
  }
}
