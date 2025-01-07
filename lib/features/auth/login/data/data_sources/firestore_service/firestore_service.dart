import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/auth/login/data/data_sources/firestore_service/firestore_param.dart';
import '../../../../../../core/helpers/enums/user_type.dart';
import '../../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirestoreService();

  Future<void> saveUserToFirestore(User user, FirestoreParam param) async {
    try {
      final userDoc = await _db.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        final appUser = UserModel(
          phoneNumber: param.phoneNumber ?? '',
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          city: param.city ?? '',
          type: param.type ?? '',
          currentTripId: param.currentTripId ?? '',
        );
        await _db.collection('users').doc(user.uid).set(appUser.toJson());
      } else {
        safePrint("User data already exists in Firestore.");
      }
    } catch (e) {
      throw Exception("Error saving user data to Firestore: $e");
    }
  }
  Future<void> saveUserModeToFirestore(String mode) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _db.collection('users').doc(user.uid).update({
          'type': mode,
        });
      }
    } catch (e) {
      throw Exception("Error saving user mode to Firestore: $e");
    }
  }
  Future<void> updatePhoneNumberToFirestore(String phoneNumber) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await _db.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userType = userDoc['type'];

          await _db.collection('users').doc(user.uid).update({
            'phoneNumber': phoneNumber,
          });

          if (userType == UserType.driver.name) {
            await _db.collection("drivers").doc(user.uid).update({
              "personalInfo.phone": phoneNumber,
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Error saving user phone number to Firestore: $e");
    }
  }

    Future<void> updateUserCityToFirestore(String city) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await _db.collection('users').doc(user.uid).update({
            'city': city,
          });
        }
      } catch (e) {
        throw Exception("Error saving user city to Firestore: $e");

    }
  }
}
