import '../../../data/models/user.dart';

class GoogleState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  GoogleState({this.user, this.isLoading = false, this.error});

  GoogleState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return GoogleState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
