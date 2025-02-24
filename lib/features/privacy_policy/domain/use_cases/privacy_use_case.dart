import 'package:ride_now/features/privacy_policy/data/repositories/privacy_repo.dart';

class FetchPrivacyPolicyUseCase {
  final PrivacyRepository repository;
  FetchPrivacyPolicyUseCase(this.repository);

  Future<String> call() async {
    return await repository.getPrivacyPolicy();
  }
}
