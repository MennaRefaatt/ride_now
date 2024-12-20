import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send OTP to the phone number
  Future<void> sendOTP(String phoneNumber, Function(PhoneAuthCredential) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in when verification is completed
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e.message!;
      },
      codeSent: (String verificationId, int? resendToken) {
        // OTP sent successfully, call the callback function
        onCodeSent(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: ''));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout if needed
      },
    );
  }

  // Verify the OTP
  Future<void> verifyOTP(String verificationId, String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    await _auth.signInWithCredential(credential);
  }
}
