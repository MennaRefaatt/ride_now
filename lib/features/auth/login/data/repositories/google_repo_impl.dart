import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/core/services/wallet/wallet_service.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/enums/user_type.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/services/fcm/device_token_service.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../phone_args.dart';
import '../../domain/repositories/google_repo_base.dart';
import '../data_sources/firestore_service/firestore_param.dart';
import '../data_sources/firestore_service/firestore_service.dart';
import '../data_sources/google_sign_in/google_sign_in.dart';
import '../data_sources/remote_data_source/local_data_source.dart';
import '../models/user.dart';

class GoogleRepositoryImpl implements GoogleRepositoryBase {
  final DSGoogleSignIn _dsGoogleSignIn;
  final FirestoreService _firestoreService;
  final DSAuthLocal _dsAuthLocal;
  final WalletService _walletService;

  GoogleRepositoryImpl(this._walletService, this._dsGoogleSignIn,
      this._firestoreService, this._dsAuthLocal);

  @override
  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    final user = await _dsGoogleSignIn.signInWithGoogle();
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
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
        await _firestoreService
            .saveUserToFirestore(user, param)
            .then((value) async {
          final userModel = UserModel(
            city: param.city ?? '',
            type: param.type ?? '',
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL ?? '',
            phoneNumber: param.phoneNumber ?? '',
            currentTripId: param.currentTripId ?? '',
            deviceToken: deviceToken ?? '',
          );
          await _dsAuthLocal.saveDataToLocal(userModel);
          if (user.photoURL != null) {
            await _firestoreService.uploadProfileImage(File(user.photoURL!));
          }
          if (phone == "missing phone number") {
            Navigator.pushReplacementNamed(
                context, RoutingEndpoints.phoneNumber,
                arguments: PhoneArgs(user: user));
          }
        });
      } else {
        await _walletService.createWalletForUser(user.uid);
        String phoneNumber = userDoc.data()?['phoneNumber'] ?? '';
        if (phoneNumber == "missing phone number" || phoneNumber.isEmpty) {
          Navigator.pushReplacementNamed(context, RoutingEndpoints.phoneNumber,
              arguments: PhoneArgs(user: user));
        } else if (phoneNumber.isNotEmpty) {
          final userModel = UserModel(
            city: userDoc.data()?['city'] ?? '',
            type: userDoc.data()?['type'] ?? '',
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL ?? '',
            phoneNumber: phoneNumber,
            currentTripId: userDoc.data()?['currentTripId'] ?? '',
            deviceToken: userDoc.data()?['deviceToken'] ?? '',
          );
          await _dsAuthLocal.saveDataToLocal(userModel).then((value) {
            final userType = SharedPref.getString(key: MySharedKeys.type);
            if (userType == UserType.driver.name) {
              Navigator.pushReplacementNamed(
                  context, RoutingEndpoints.driverHome);
            } else {
              Navigator.pushReplacementNamed(
                  context, RoutingEndpoints.passengerHome);
            }
          });
        } else {
          Navigator.pushReplacementNamed(context, RoutingEndpoints.phoneNumber,
              arguments: PhoneArgs(user: user));
        }
      }
    }
    return null;
  }

  Future<String> _promptForPhoneNumber() async {
    return 'missing phone number';
  }

  @override
  Future<void> signOutGoogle() async {
    await _dsGoogleSignIn.signOutGoogle();
    await FirebaseAuth.instance.signOut();
  }
}

final googleRepositoryProvider = Provider<GoogleRepositoryBase>((ref) {
  final googleSignInService = GoogleSignInServiceImpl();
  final firestoreService = FirestoreService(sl(), sl());
  final walletService = WalletService(FirebaseFirestore.instance);

  return GoogleRepositoryImpl(
      walletService, googleSignInService, firestoreService, DSAuthLocalImpl());
});
