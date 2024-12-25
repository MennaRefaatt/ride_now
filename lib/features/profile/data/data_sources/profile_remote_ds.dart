import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../models/profile_model.dart';

abstract class ProfileRemoteDS {
  Future<ProfileModel> getProfile(String userId);
  Future<void> saveProfile(ProfileModel profile);
}

class ProfileRemoteDSImpl implements ProfileRemoteDS {
  final FirebaseFirestore firestore;

  ProfileRemoteDSImpl(this.firestore);

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
  Future<void> saveProfile(ProfileModel profile) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(profile.uid);
    await userRef.set(profile.toJson(), SetOptions(merge: true));
  }
}
