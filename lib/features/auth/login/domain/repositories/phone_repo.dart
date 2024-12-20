import 'package:firebase_auth/firebase_auth.dart';
import '../../data/data_sources/phone_auth_service/phone_auth_service.dart';

class PhoneAuthRepository {
  final PhoneAuthService _phoneAuthService;

  PhoneAuthRepository(this._phoneAuthService);

  Future<void> sendOTP(String phoneNumber, Function(PhoneAuthCredential) onCodeSent) async {
    await _phoneAuthService.sendOTP(phoneNumber, onCodeSent);
  }

  Future<void> verifyOTP(String verificationId, String otp) async {
    await _phoneAuthService.verifyOTP(verificationId, otp);
  }
}
