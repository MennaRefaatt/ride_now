import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceTokenService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> saveDeviceToken(String token) async {
    await _secureStorage.write(key: 'device_token', value: token);
  }

  Future<String?> getStoredDeviceToken() async {
    return await _secureStorage.read(key: 'device_token');
  }

  Future<void> updateDeviceTokenIfNeeded(String userId) async {
    String? newToken = await getDeviceToken();
    String? storedToken = await getStoredDeviceToken();

    if (newToken != null && newToken != storedToken) {
      await saveDeviceToken(newToken);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'deviceToken': newToken,
      });
    }
  }
}
