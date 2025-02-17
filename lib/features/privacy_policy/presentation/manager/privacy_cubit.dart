import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/use_cases/privacy_use_case.dart';

part 'privacy_state.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  final FetchPrivacyPolicyUseCase _fetchPrivacyPolicy;
  PrivacyCubit(this._fetchPrivacyPolicy) : super(PrivacyPolicyLoading());

  Future<void> loadPrivacyPolicy() async {
    emit(PrivacyPolicyLoading());
    try {
      final policy = await _fetchPrivacyPolicy();
      emit(PrivacyPolicyLoaded(policy));
    } catch (e) {
      emit(PrivacyPolicyError('Failed to fetch privacy policy.'));
    }
  }
}
