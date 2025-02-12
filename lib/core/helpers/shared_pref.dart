import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }

  static Future<void> clearUserData() async {
    await putString(key: MySharedKeys.userId, value: "");
    await putString(key: MySharedKeys.userName, value: "");
    await putString(key: MySharedKeys.picture, value: "");
    await putString(key: MySharedKeys.email, value: "");
    await putString(key: MySharedKeys.phone, value: "");
  }

  static void putBoolean({
    required MySharedKeys key,
    required bool value,
  }) async {
    await _preferences?.setBool(key.name, value);
  }

  static bool getBoolean({
    required MySharedKeys key,
    bool defaultValue = false,
  }) {
    return _preferences?.getBool(key.name) ?? defaultValue;
  }

  static Future<bool> putString({
    required MySharedKeys key,
    required String? value,
  }) async {
    return await _preferences?.setString(key.name, value ?? "") ?? false;
  }

  static Future<bool> putDouble({
    required MySharedKeys key,
    required double? value,
  }) async {
    return await _preferences?.setDouble(key.name, value ?? 0) ?? false;
  }

  static Future<bool> putInt({
    required MySharedKeys key,
    required int? value,
  }) async {
    return await _preferences?.setInt(key.name, value ?? 0) ?? false;
  }

  static int? getInt({required MySharedKeys key}) {
    return _preferences?.getInt(key.name);
  }

  static double? getDouble({required MySharedKeys key}) {
    return _preferences?.getDouble(key.name);
  }

  static Object setString({required MySharedKeys key, required String value}) {
    return _preferences?.setString(key.name, value) ?? "";
  }

  static String? getString({required MySharedKeys key}) {
    return _preferences?.getString(key.name) ?? "";
  }

  static String getCurrentLanguage() {
    return _preferences?.getString(MySharedKeys.currentLanguage.name) ?? "en";
  }
  static Future<void> setCurrentLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MySharedKeys.currentLanguage.name, languageCode);
  }

  static bool isLoggedIn() {
    return getString(key: MySharedKeys.userId).toString().isNotEmpty;
  }

  static bool isEnglish() => getCurrentLanguage() == "en";

  static bool isFirstOpen() {
    return _preferences?.getBool(MySharedKeys.firstOpen.name) ?? true;
  }

  static Future<void> setFirstOpen(bool value) async {
    await _preferences?.setBool(MySharedKeys.firstOpen.name, value);
  }

  // Method to store driver data when driver is accepted
  static Future<void> storeDriverData({
    required String driverId,
    required String driverStatus,
    required String driverTripStatus,
    required String driverName,
    required String driverPicture,
    required String carNumber,
    required String carColor,
    required String carModel,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await putString(key: MySharedKeys.driverId, value: driverId);
      await putString(key: MySharedKeys.driverStatus, value: driverStatus);
      await putString(
          key: MySharedKeys.driverTripStatus, value: driverTripStatus);
      await putString(key: MySharedKeys.driverName, value: driverName);
      await putString(key: MySharedKeys.driverPicture, value: driverPicture);
      await putString(key: MySharedKeys.carNumber, value: carNumber);
      await putString(key: MySharedKeys.carColor, value: carColor);
      await putString(key: MySharedKeys.carModel, value: carModel);
      await putDouble(key: MySharedKeys.driverLatitude, value: latitude);
      await putDouble(key: MySharedKeys.driverLongitude, value: longitude);

      safePrint("Driver data successfully stored in SharedPreferences");
    } catch (e) {
      safePrint("Error storing driver data in SharedPreferences: $e");
    }
  }

  // private constructor as I don't want to allow creating an instance of this class itself.
  SharedPref._();
}
