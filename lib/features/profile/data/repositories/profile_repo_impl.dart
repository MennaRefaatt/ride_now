import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/profile/domain/repositories/profile_repo_base.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../data_sources/profile_remote_ds.dart';
import '../models/profile_model.dart';

class ProfileRepoImpl implements ProfileRepoBase {
  final ProfileRemoteDS remoteDS;

  ProfileRepoImpl(this.remoteDS);

  @override
  Future<ProfileModel> getProfile() async {
    final userId = SharedPref.getString(key: MySharedKeys.userId)!;
    final getProfile = await remoteDS.getProfile(userId);
    try {
      safePrint(userId);
      if(getProfile.uid == userId) {
        return getProfile;
      }
    }
    catch (e) {
      safePrint(e);
      return Future.error(e);
    }

    return getProfile;
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await remoteDS.saveProfile(profile);
  }
}
