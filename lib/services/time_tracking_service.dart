import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/models/time_entry_model.dart';

class TimeTrackingService {
  final _db = FirebaseFirestore.instance;

  Future<void> clockIn(String userId) async {
    // Check if already clocked in
    final active = await getCurrentSession(userId).first;
    if (active != null) return; // Already clocked in

    final id = const Uuid().v4();
    final entry = TimeEntryModel(
      id: id,
      userId: userId,
      clockIn: DateTime.now(),
      status: TimeEntryStatus.active,
    );

    await _db.collection('time_entries').doc(id).set(entry.toJson());
  }

  Future<void> clockOut(String userId) async {
    final active = await getCurrentSession(userId).first;
    if (active == null) return;

    final updated = active.copyWith(
      clockOut: DateTime.now(),
      status: TimeEntryStatus.completed,
    );

    await _db.collection('time_entries').doc(active.id).update(updated.toJson());
  }

  Stream<TimeEntryModel?> getCurrentSession(String userId) {
    return _db.collection('time_entries')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active') // Enum serialized as string usually
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return TimeEntryModel.fromJson(snapshot.docs.first.data());
        });
  }
}
