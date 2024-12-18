import '../../../data/models/user.dart';

class FacebookState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  FacebookState({this.user, this.isLoading = false, this.error});

  FacebookState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return FacebookState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
