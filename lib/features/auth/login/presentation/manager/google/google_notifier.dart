import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/google_repo.dart';
import 'google_states.dart';

class GoogleNotifier extends StateNotifier<GoogleState> {
  final GoogleRepository _googleRepository;

  GoogleNotifier(this._googleRepository) : super(GoogleState());

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await _googleRepository.signInWithGoogle();

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      } else {
        state =
            state.copyWith(isLoading: false, error: "Google sign-in failed");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final googleNotifierProvider =
    StateNotifierProvider<GoogleNotifier, GoogleState>((ref) {
  final googleRepository = ref.watch(userRepositoryProvider);
  return GoogleNotifier(googleRepository);
});
