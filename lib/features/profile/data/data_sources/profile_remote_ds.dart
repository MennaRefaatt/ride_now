import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../models/profile_model.dart';

abstract class ProfileRemoteDS {
  Future<ProfileModel> getProfile(String userId);
  Future<void> saveProfile(ProfileModel profile);
}

class ProfileRemoteDSImpl implements ProfileRemoteDS {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  ProfileRemoteDSImpl(this.firestore, this.storage);

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    try {
      safePrint("profile data: ${doc.data()}");
      var data = doc.data() ?? {};
      ProfileModel profile = ProfileModel.fromJson(data);
      safePrint("get profile: $profile");
      return profile;
    } catch (e) {
      safePrint("get profile error: $e");
      return Future.error(e);
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profile, {File? imageFile}) async {
    try {
      final userRef = firestore.collection('users').doc(profile.uid);

      if (imageFile != null) {
        String photoUrl = await uploadProfileImage(imageFile);
        profile = profile.copyWith(photoUrl: photoUrl);
      }

      final result = await userRef.set(profile.toJson(), SetOptions(merge: true));
      safePrint("Profile saved: $profile");
      return result;
    } catch (e) {
      safePrint("Save profile error: $e");
      return Future.error(e);
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String filePath = 'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference reference = storage.ref().child(filePath);

      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      safePrint("Error uploading profile image: $e");
      rethrow;
    }
  }

}
