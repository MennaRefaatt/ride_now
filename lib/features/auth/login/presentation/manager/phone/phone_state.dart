import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/features/auth/login/presentation/manager/phone/phone_notifier.dart';

import '../../../data/data_sources/phone_auth_service/phone_auth_service.dart';
import '../../../domain/repositories/phone_repo.dart';

class PhoneAuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? verificationId; // Add this field for storing the verificationId

  PhoneAuthState({
    this.isLoading = false,
    this.errorMessage,
    this.verificationId,
  });

  // Create a copyWith method for handling state changes
  PhoneAuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? verificationId,
  }) {
    return PhoneAuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

final phoneAuthNotifierProvider = StateNotifierProvider<PhoneAuthNotifier, PhoneAuthState>(
      (ref) {
    // You need to provide a PhoneAuthRepository, which may be instantiated here or passed in
    final phoneAuthRepository = PhoneAuthRepository(PhoneAuthService());
    return PhoneAuthNotifier(phoneAuthRepository);
  },
);

