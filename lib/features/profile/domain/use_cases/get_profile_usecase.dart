import 'package:ride_now/features/profile/domain/repositories/profile_repo_base.dart';
import '../../data/models/profile_model.dart';

class GetProfileUseCase {
  final ProfileRepoBase repository;

  GetProfileUseCase(this.repository);

  Future<ProfileModel> execute() async {
    return await repository.getProfile();
  }
}

