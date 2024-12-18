import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/facebook_repo.dart';
import 'facebook_states.dart';

class FacebookNotifier extends StateNotifier<FacebookState> {
  final FacebookRepository _facebookRepository;

  FacebookNotifier(this._facebookRepository) : super(FacebookState());

  Future<void> signInWithFacebook() async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await _facebookRepository.signInWithFacebook();

      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, error: "Facebook sign-in failed");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final facebookNotifierProvider =
StateNotifierProvider<FacebookNotifier, FacebookState>((ref) {
  final facebookRepository = ref.watch(facebookRepositoryProvider);
  return FacebookNotifier(facebookRepository);
});
