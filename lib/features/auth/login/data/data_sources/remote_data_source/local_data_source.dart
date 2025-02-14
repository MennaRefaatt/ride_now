import 'package:ride_now/core/helpers/shared_pref.dart';

import '../../../../../../core/di/di.dart';
import '../../../../../../core/helpers/secure_storage/secure_keys.dart';
import '../../../../../../core/helpers/secure_storage/secure_storage.dart';
import '../../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../../core/services/f_c_m_service/device_token_service.dart';
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
    SharedPref.setString(key: MySharedKeys.phone, value: user.phoneNumber);
    SharedPref.setString(key: MySharedKeys.picture, value: user.photoUrl);
    SharedPref.setString(key: MySharedKeys.city, value: user.city ?? '');
    SharedPref.setString(key: MySharedKeys.type, value: user.type ?? '');
    SharedPref.setString(key: MySharedKeys.currentTripId, value: user.currentTripId ?? '');

    final deviceTokenService = sl<DeviceTokenService>();
    String? deviceToken = await deviceTokenService.getDeviceToken();

    if (deviceToken != null) {
      await SecureStorageService.writeData(SecureKeys.deviceToken, deviceToken);
    }
  }

  @override
  Future<UserModel> getDataFromLocal() async {
    String? deviceToken = await SecureStorageService.readData(SecureKeys.deviceToken);

    return UserModel(
      city: SharedPref.getString(key: MySharedKeys.city) ?? '',
      type: SharedPref.getString(key: MySharedKeys.type) ?? '',
      email: SharedPref.getString(key: MySharedKeys.email) ?? '',
      uid: SharedPref.getString(key: MySharedKeys.userId) ?? '',
      name: SharedPref.getString(key: MySharedKeys.userName) ?? '',
      phoneNumber: SharedPref.getString(key: MySharedKeys.phone) ?? '',
      photoUrl: SharedPref.getString(key: MySharedKeys.picture) ?? '',
      currentTripId: SharedPref.getString(key: MySharedKeys.currentTripId) ?? '',
      deviceToken: deviceToken ?? '',
    );
  }

  @override
  Future<void> clear() async {
    SharedPref.clear();
    await SecureStorageService.deleteData(SecureKeys.deviceToken);
  }
}
