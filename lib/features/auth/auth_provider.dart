import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../core/models/user_model.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) {
    debugPrint('userProfileProvider: No auth state');
    return null;
  }
  
  debugPrint('userProfileProvider: Fetching profile for ${authState.uid}');
  try {
    final profile = await ref.read(authServiceProvider).getUserProfile(authState.uid);
    debugPrint('userProfileProvider: Profile fetched: ${profile != null}');
    return profile;
  } catch (e) {
    debugPrint('userProfileProvider: Error fetching profile: $e');
    rethrow;
  }
});

final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList());
});
