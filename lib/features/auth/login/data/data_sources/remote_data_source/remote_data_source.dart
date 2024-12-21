import 'package:ride_now/core/helpers/shared_pref.dart';

import '../../../../../../core/helpers/shared_pref_keys.dart';
import '../../models/user.dart';

abstract class DSAuthLocal {
  Future<void> saveDataToLocal(UserModel user);
  Future<void> clear();
  Future<UserModel> getDataFromLocal();
}

class DSAuthLocalImpl implements DSAuthLocal {
  @override
  Future<void> saveDataToLocal(UserModel user) async {
    SharedPref.setString(key: MySharedKeys.email, value: user.email);
    SharedPref.setString(key: MySharedKeys.userId, value: user.uid);
    SharedPref.setString(key: MySharedKeys.userName, value: user.name);
  }

  @override
  Future<UserModel> getDataFromLocal() async {
    UserModel user = UserModel(
      email: SharedPref.getString(key: MySharedKeys.email) ?? "",
      uid: SharedPref.getString(key: MySharedKeys.userId) ?? "",
      name: SharedPref.getString(key: MySharedKeys.userName) ?? "",
      phoneNumber: SharedPref.getString(key: MySharedKeys.phone) ?? "",
      photoUrl: SharedPref.getString(key: MySharedKeys.picture) ?? "",
    );
    return user;
  }
  @override
  Future<void> clear() async {
    SharedPref.clear();
  }
}
