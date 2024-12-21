import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/features/auth/login/data/data_sources/facebook_sign_in/facebook_sign_in.dart';
import 'package:ride_now/features/auth/login/data/data_sources/remote_data_source/remote_data_source.dart';
import '../../domain/repositories/facebook_repo_base.dart';
import '../data_sources/firestore_service/firestore_service.dart';
import '../models/user.dart';

class FacebookRepositoryImpl implements FacebookRepositoryBase {
  final DSFacebookSignIn _dsFacebookSignIn;
  final DSAuthLocal _dsAuthLocal;
  final FirestoreService _firestoreService;

  FacebookRepositoryImpl(this._dsFacebookSignIn, this._firestoreService,
      this._dsAuthLocal);

  @override
  Future<UserModel?> signInWithFacebook() async {
    final user = await _dsFacebookSignIn.signInWithFacebook();

    if (user != null) {
      String phone = user.phoneNumber ?? '';
      if (phone.isEmpty) {
        phone = await _promptForPhoneNumber();
      }
      await _firestoreService.saveUserToFirestore(user, phone);

      final userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        phoneNumber: phone,
      );

      await _dsAuthLocal
          .saveDataToLocal(userModel);
      return userModel;
    }
    return null;
  }

  Future<String> _promptForPhoneNumber() async {
    return 'missing phone number';
  }

  @override
  Future<void> signOutFacebook() async {
    await _dsFacebookSignIn.signOutFacebook();
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
  }
}

final facebookRepositoryProvider = Provider<FacebookRepositoryBase>((ref) {
  final facebookSignInService = DSFacebookSignInImpl();
  final firestoreService = FirestoreService();
  return FacebookRepositoryImpl(
      facebookSignInService, firestoreService, DSAuthLocalImpl());
});
