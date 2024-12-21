import 'package:firebase_auth/firebase_auth.dart';

abstract class PhoneAuthRepositoryBase {
  Future<void> sendOtp(String phoneNumber, Function(PhoneAuthCredential) onCodeSent);
  Future<void> verifyOtp(String verificationId, String otp);
}
