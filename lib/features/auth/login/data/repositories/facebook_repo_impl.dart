import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/features/auth/login/data/data_sources/facebook_sign_in/facebook_sign_in.dart';
import 'package:ride_now/features/auth/login/data/data_sources/firestore_service/firestore_param.dart';
import 'package:ride_now/features/auth/login/data/data_sources/remote_data_source/local_data_source.dart';
import '../../../../../core/helpers/enums/user_type.dart';
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
      final param = FirestoreParam(
        phoneNumber: phone,
        city: "missing to pick the location",
        type: UserType.passenger.name,
        currentTripId: "none",

      );
      await _firestoreService.saveUserToFirestore(user,param);

      final userModel = UserModel(
        city: param.city ?? '',
        type: param.type ?? '',
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        phoneNumber: param.phoneNumber ?? '',
        currentTripId: param.currentTripId ?? '',
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
