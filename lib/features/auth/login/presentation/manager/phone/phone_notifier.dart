import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/features/auth/login/presentation/manager/phone/phone_state.dart';
import '../../../../../../core/services/routing/routing_endpoints.dart';
import '../../../domain/repositories/phone_repo.dart';

class PhoneAuthNotifier extends StateNotifier<PhoneAuthState> {
  final PhoneAuthRepository _phoneAuthRepository;

  PhoneAuthNotifier(this._phoneAuthRepository) : super(PhoneAuthState());

  Future<void> sendOtp(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true);
      await _phoneAuthRepository.sendOTP(
        phoneNumber,
            (PhoneAuthCredential credential) {
          // Handle OTP sent callback
          state = state.copyWith(verificationId: credential.verificationId);
        },
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> verifyOtp(String otp, BuildContext context) async {
    try {
      if (state.verificationId == null) {
        throw "Verification ID is missing";
      }
      await _phoneAuthRepository.verifyOTP(state.verificationId!, otp);
      state = state.copyWith(isLoading: false);
      Navigator.pushReplacementNamed(context, RoutingEndpoints.home); // Navigate to Home
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}
