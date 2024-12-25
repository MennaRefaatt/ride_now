import 'package:ride_now/features/profile/domain/repositories/profile_repo_base.dart';
import '../../data/models/profile_model.dart';

class SaveProfileUseCase {
  final ProfileRepoBase repository;

  SaveProfileUseCase(this.repository);

  Future<void> execute(ProfileModel profile) async {
    await repository.saveProfile(profile);
  }
}
