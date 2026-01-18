import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/user_model.dart';
import '../core/models/user_role.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update user profile in Firestore
  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.id).update(user.toJson());
  }

  // Delete user from Firestore (note: this doesn't delete from Firebase Auth, 
  // which requires Admin SDK or being the user. For a real app, use a Cloud Function)
  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // Complete onboarding flow
  Future<void> completeOnboarding(String name, String password) async {
    final user = _auth.currentUser;
    if (user != null) {
      // 1. Update Password
      await user.updatePassword(password);
      
      // 2. Update Firestore profile
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final userModel = UserModel.fromJson({...doc.data()!, 'id': doc.id});
        final updatedModel = userModel.copyWith(
          name: name,
          isFirstLogin: false,
        );
        await updateUser(updatedModel);
      }
    }
  }

  // Helper method for first-time admin setup
  Future<void> createAdminAccount(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final userModel = UserModel(
      id: cred.user!.uid,
      name: name,
      email: email,
      role: UserRole.admin,
      isFirstLogin: false, // Admin created directly shouldn't need onboarding
    );
    await _db.collection('users').doc(cred.user!.uid).set(userModel.toJson());
  }
}
