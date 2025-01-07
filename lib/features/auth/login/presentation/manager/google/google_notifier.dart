import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/google_repo_impl.dart';
import '../../../domain/repositories/google_repo_base.dart';
import 'google_states.dart';

class GoogleNotifier extends StateNotifier<GoogleState> {
  final GoogleRepositoryBase _googleRepository;

  GoogleNotifier(this._googleRepository) : super(GoogleState());

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await _googleRepository.signInWithGoogle(context);

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

  Future<void> signOutGoogle() async {
    await _googleRepository.signOutGoogle();
    state = state.copyWith(user: null, error: null);
  }
}

final googleNotifierProvider =
    StateNotifierProvider<GoogleNotifier, GoogleState>((ref) {
  final googleRepository = ref.watch(googleRepositoryProvider);
  return GoogleNotifier(googleRepository);
});
