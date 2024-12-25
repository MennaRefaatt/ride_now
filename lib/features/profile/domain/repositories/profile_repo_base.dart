
import '../../data/models/profile_model.dart';

abstract class ProfileRepoBase {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
}
