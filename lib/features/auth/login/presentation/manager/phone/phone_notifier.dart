import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/auth/login/presentation/manager/phone/phone_state.dart';
import '../../../data/repositories/phone_repo_impl.dart';
import '../../../domain/repositories/phone_repo_base.dart';
class PhoneAuthNotifier extends StateNotifier<PhoneAuthState> {
  final PhoneAuthRepositoryBase _phoneAuthRepository;

  PhoneAuthNotifier(this._phoneAuthRepository) : super(PhoneAuthState());

  Future<void> sendOtp(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true);
      await _phoneAuthRepository.sendOtp(
        phoneNumber,
            (PhoneAuthCredential credential) {
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
      await _phoneAuthRepository.verifyOtp(state.verificationId!, otp);
      state = state.copyWith(isLoading: false);
      Navigator.pushReplacementNamed(context, RoutingEndpoints.home); // Navigate to Home
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}
final phoneNotifierProvider = StateNotifierProvider<PhoneAuthNotifier, PhoneAuthState>((ref) {
  final phoneAuthRepository = ref.watch(phoneRepositoryProvider);
  return PhoneAuthNotifier(phoneAuthRepository);
});
