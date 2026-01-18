import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/history_archive_model.dart';
import '../core/models/daily_statistic_model.dart';
import '../core/models/user_model.dart';

class HistoryService {
  final _db = FirebaseFirestore.instance;

  /// Resets user statistics and moves them to an archive.
  /// This is typically called by an Admin.
  Future<void> archiveAndResetStats(UserModel user) async {
    // 1. Fetch all current daily statistics for the user
    final statsSnapshot = await _db.collection('daily_statistics')
        .where('userId', isEqualTo: user.id)
        .get();

    if (statsSnapshot.docs.isEmpty) return;

    final batch = _db.batch();

    double totalSales = 0;
    double totalTips = 0;
    int totalOrders = 0;

    for (var doc in statsSnapshot.docs) {
      final stats = DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id});
      totalSales += stats.sales;
      totalTips += stats.tips;
      totalOrders += stats.orderCount;

      // Mark for deletion or clearing
      batch.delete(doc.reference);
    }

    // 2. Create Archive entry
    final archiveRef = _db.collection('history_archives').doc();
    final archive = HistoryArchiveModel(
      id: archiveRef.id,
      userId: user.id,
      userName: user.name,
      date: DateTime.now(),
      totalSales: totalSales,
      totalTips: totalTips,
      orderCount: totalOrders,
      archivedAt: DateTime.now(),
    );

    batch.set(archiveRef, archive.toJson());

    // 3. Optional: Clear user's current shift data if any
    // This is handled per shift, but we could also reset shift totals here.

    await batch.commit();
  }

  /// Automated cleanup: Delete history older than 7 days for a specific user.
  /// Note: In a production app, this would be best handled by a Firebase Cloud Function.
  Future<void> cleanupOldHistory(String userId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    
    final oldStats = await _db.collection('daily_statistics')
        .where('userId', isEqualTo: userId)
        .where('date', isLessThan: sevenDaysAgo)
        .get();

    final batch = _db.batch();
    for (var doc in oldStats.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
}
