import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/models/work_schedule_model.dart';

class ScheduleService {
  final _db = FirebaseFirestore.instance;

  Future<void> addSchedule(WorkSchedule schedule) async {
    await _db.collection('work_schedules').doc(schedule.id).set(schedule.toJson());
  }

  Future<void> deleteSchedule(String id) async {
    await _db.collection('work_schedules').doc(id).delete();
  }

  Stream<List<WorkSchedule>> getSchedulesForMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1).subtract(const Duration(milliseconds: 1));

    return _db.collection('work_schedules')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) {
          final schedules = <WorkSchedule>[];
          for (var doc in snapshot.docs) {
            try {
              schedules.add(WorkSchedule.fromJson({
                ...doc.data(),
                'id': doc.id,
              }));
            } catch (e) {
              // Log but don't crash
              debugPrint('Error parsing schedule doc ${doc.id}: $e');
            }
          }
          return schedules;
        });
  }

  Stream<List<WorkSchedule>> getUserSchedules(String userId, DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1).subtract(const Duration(milliseconds: 1));
    
    return _db.collection('work_schedules')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
          final schedules = <WorkSchedule>[];
          for (var doc in snapshot.docs) {
            try {
              schedules.add(WorkSchedule.fromJson({
                ...doc.data(),
                'id': doc.id,
              }));
            } catch (e) {
              debugPrint('Error parsing schedule doc ${doc.id}: $e');
            }
          }
          return schedules;
        });
  }
}
