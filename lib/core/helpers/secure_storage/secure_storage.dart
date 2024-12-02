import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ride_now/core/helpers/secure_storage/secure_keys.dart';

class SecureStorageService {
  static  const FlutterSecureStorage _storage = FlutterSecureStorage();

 static Future<void> writeData(SecureKeys secureKeys, String value) async {
    await _storage.write(key: secureKeys.name, value: value);
  }

 static Future<String?> readData(SecureKeys secureKeys) async {
    return _storage.read(key: secureKeys.name);
  }

  static Future<void> deleteData(SecureKeys secureKeys) async {
    await _storage.delete(key: secureKeys.name);
  }

  static Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }
}
