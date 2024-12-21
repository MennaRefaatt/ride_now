import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

abstract class DSPhoneAuthService {
  Future<void> sendOTP(String phoneNumber, Function(PhoneAuthCredential) onCodeSent);
  Future<void> verifyOTP(String verificationId, String otp);
}

class DSPhoneAuthServiceImpl implements DSPhoneAuthService {
  DSPhoneAuthServiceImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> sendOTP(String phoneNumber, Function(PhoneAuthCredential) onCodeSent) async {
    try {
      if (!RegExp(r'^\+\d{1,15}$').hasMatch(phoneNumber)) {
        throw Exception("Invalid phone number format. Use E.164 format (+[country code][number]).");
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'quota-exceeded') {
            throw Exception("SMS quota exceeded. Please try again later.");
          } else if (e.code == 'operation-not-allowed') {
            throw Exception("Phone authentication is not enabled in Firebase.");
          } else {
            throw Exception(e.message ?? "Phone verification failed.");
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: ''));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout if needed
        },
      );
    } catch (e) {
      safePrint("Error during OTP sending: $e");
      throw Exception("Failed to send OTP: ${e.toString()}");
    }
  }

  @override
  Future<void> verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      safePrint("Error during OTP verification: $e");
      throw Exception("Failed to verify OTP: ${e.toString()}");
    }
  }
}
