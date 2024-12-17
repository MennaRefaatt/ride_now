// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserToFirestore(User user, String phoneNumber) async {
    try {
      final appUser = UserModel(
        phoneNumber: phoneNumber,
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
      );
      await _db.collection('users').doc(user.uid).set(appUser.toJson());
    } catch (e) {
      throw Exception("Error saving user data to Firestore: $e");
    }
  }
}
