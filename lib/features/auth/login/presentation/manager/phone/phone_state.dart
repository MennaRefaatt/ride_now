
class PhoneAuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? verificationId;

  PhoneAuthState({
    this.isLoading = false,
    this.errorMessage,
    this.verificationId,
  });

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
