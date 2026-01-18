import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/daily_statistic_model.dart';
import '../auth/auth_provider.dart';

// Stream of daily statistics for the logged-in user
final userDailyStatsProvider = StreamProvider<List<DailyStatisticModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('daily_statistics')
      .where('userId', isEqualTo: user.uid)
      .orderBy('date', descending: true)
      .limit(7) // Last 7 days as per requirements
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});

// Stream of aggregated statistics for admin (all users)
final adminAggregateStatsProvider = StreamProvider<List<DailyStatisticModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('daily_statistics')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DailyStatisticModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});
