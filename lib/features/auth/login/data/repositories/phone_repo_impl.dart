import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/phone_repo_base.dart';
import '../data_sources/firestore_service/firestore_service.dart';
import '../data_sources/phone_auth_service/phone_auth_service.dart';
import '../data_sources/remote_data_source/remote_data_source.dart';
import '../models/user.dart';
class PhoneAuthRepositoryImpl implements PhoneAuthRepositoryBase {
  final DSPhoneAuthService _dsPhoneAuthService;
  final FirestoreService _firestoreService;
  final DSAuthLocal _dsAuthLocal;

  PhoneAuthRepositoryImpl(
      this._dsPhoneAuthService, this._firestoreService, this._dsAuthLocal);

  @override
  Future<void> sendOtp(
      String phoneNumber, Function(PhoneAuthCredential) onCodeSent) async {
    try {
      await _dsPhoneAuthService.sendOTP(phoneNumber, onCodeSent);
    } catch (e) {
      throw Exception("PhoneAuthRepository: ${e.toString()}");
    }
  }

  @override
  Future<void> verifyOtp(String verificationId, String otp) async {
    try {
      await _dsPhoneAuthService.verifyOTP(verificationId, otp);
    } catch (e) {
      throw Exception("PhoneAuthRepository: ${e.toString()}");
    }
  }

  Future<UserModel> saveUserData(String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        phoneNumber: phoneNumber,
      );

      await _firestoreService.saveUserToFirestore(user, phoneNumber);
      await _dsAuthLocal.saveDataToLocal(userModel);

      return userModel;
    }
    throw Exception("User not authenticated");
  }
}

final phoneRepositoryProvider = Provider<PhoneAuthRepositoryBase>((ref) {
  final phoneAuthService = DSPhoneAuthServiceImpl();
  final firestoreService = FirestoreService();
  return PhoneAuthRepositoryImpl(
      phoneAuthService, firestoreService, DSAuthLocalImpl());
});
