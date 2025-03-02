import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/features/auth/login/data/data_sources/facebook_sign_in/facebook_sign_in.dart';
import 'package:ride_now/features/auth/login/data/data_sources/firestore_service/firestore_param.dart';
import 'package:ride_now/features/auth/login/data/data_sources/local_data_source/local_data_source.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/enums/user_type.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/services/fcm/device_token_service.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/services/wallet/wallet_service.dart';
import '../../../phone_args.dart';
import '../../domain/repositories/facebook_repo_base.dart';
import '../data_sources/firestore_service/firestore_service.dart';
import '../models/user.dart';

class FacebookRepositoryImpl implements FacebookRepositoryBase {
  final DSFacebookSignIn _dsFacebookSignIn;
  final DSAuthLocal _dsAuthLocal;
  final FirestoreService _firestoreService;
  final WalletService _walletService;

  FacebookRepositoryImpl(this._dsFacebookSignIn, this._firestoreService,
      this._dsAuthLocal, this._walletService);

  @override
  Future<UserModel?> signInWithFacebook(BuildContext context) async {
    final user = await _dsFacebookSignIn.signInWithFacebook();
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String? authPhotoUrl = user.photoURL;
      Map<String, dynamic>? userData = userDoc.data();
      String? storedPhotoUrl = (userDoc.exists && userData != null)
          ? userData['photoUrl'] as String?
          : null;

      String updatedPhotoUrl = storedPhotoUrl ?? '';

      if (!userDoc.exists || storedPhotoUrl == null || storedPhotoUrl.isEmpty) {
        if (authPhotoUrl != null && authPhotoUrl.isNotEmpty) {
          updatedPhotoUrl =
              await _firestoreService.uploadProfileImageFromUrl(user.uid) ??
                  authPhotoUrl;
        }
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'photoUrl': updatedPhotoUrl,
        }, SetOptions(merge: true));
      }

      if (!userDoc.exists) {
        await _walletService.createWalletForUser(user.uid);

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

        final deviceTokenService = sl<DeviceTokenService>();
        String? deviceToken = await deviceTokenService.getDeviceToken();

        final newUserModel = UserModel(
          city: param.city,
          type: param.type,
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: updatedPhotoUrl,
          phoneNumber: param.phoneNumber!,
          currentTripId: param.currentTripId,
          deviceToken: deviceToken ?? '',
        );

        await _firestoreService.saveUserToFirestore(user, param);
        await _dsAuthLocal.saveDataToLocal(newUserModel);

        if (updatedPhotoUrl.isNotEmpty) {
          SharedPref.setString(
              key: MySharedKeys.picture, value: updatedPhotoUrl);
        }
        if (deviceToken != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'deviceToken': deviceToken,
          });
        }

        if (phone == "missing phone number") {
          Navigator.pushReplacementNamed(context, RoutingEndpoints.phoneNumber,
              arguments: PhoneArgs(user: user));
        }
      } else {
        await _walletService.createWalletForUser(user.uid);
        String phoneNumber = userDoc.data()?['phoneNumber'] ?? '';

        if (phoneNumber.isEmpty || phoneNumber == "missing phone number") {
          Navigator.pushReplacementNamed(context, RoutingEndpoints.phoneNumber,
              arguments: PhoneArgs(user: user));
        } else {
          final updatedUserModel = UserModel(
            city: userDoc.data()?['city'] ?? '',
            type: userDoc.data()?['type'] ?? '',
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: updatedPhotoUrl,
            phoneNumber: phoneNumber,
            currentTripId: userDoc.data()?['currentTripId'] ?? '',
            deviceToken: userDoc.data()?['deviceToken'] ?? '',
          );

          await _dsAuthLocal.saveDataToLocal(updatedUserModel);

          final userType = SharedPref.getString(key: MySharedKeys.type);
          if (userType == UserType.driver.name) {
            Navigator.pushReplacementNamed(
                context, RoutingEndpoints.driverHome);
          } else {
            Navigator.pushReplacementNamed(
                context, RoutingEndpoints.passengerHome);
          }
        }
      }
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
  final firestoreService = FirestoreService(sl(), sl());
  final walletService = WalletService(FirebaseFirestore.instance);

  return FacebookRepositoryImpl(facebookSignInService, firestoreService,
      DSAuthLocalImpl(), walletService);
});
