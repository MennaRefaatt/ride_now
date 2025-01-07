import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/features/auth/login/domain/repositories/facebook_repo_base.dart';
import '../../../data/repositories/facebook_repo_impl.dart';
import 'facebook_states.dart';

class FacebookNotifier extends StateNotifier<FacebookState> {
  final FacebookRepositoryBase _facebookRepository;

  FacebookNotifier(this._facebookRepository) : super(FacebookState());

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await _facebookRepository.signInWithFacebook(context);

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      } else {
        state =
            state.copyWith(isLoading: false, error: "Facebook sign-in failed");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOutFacebook() async {
    await _facebookRepository.signOutFacebook();
    state = state.copyWith(user: null, error: null);
  }
}

final facebookNotifierProvider =
    StateNotifierProvider<FacebookNotifier, FacebookState>((ref) {
  final facebookRepository = ref.watch(facebookRepositoryProvider);
  return FacebookNotifier(facebookRepository);
});
