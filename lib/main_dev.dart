import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/driver/driver_status_listener.dart';
import 'package:ride_now/firebase_options.dart';
import 'core/components/app_entry_point.dart';
import 'core/di/di.dart';
import 'core/helpers/safe_print.dart';
import 'core/helpers/secure_storage/secure_storage.dart';
import 'core/helpers/shared_pref.dart';
import 'core/helpers/shared_pref_keys.dart';
import 'core/services/fcm/device_token_service.dart';
import 'core/services/fcm/firebase_messaging_service.dart';
import 'core/services/network/api_constants.dart';
import 'core/services/network/api_service.dart';

Future<void> main() async {
  Stripe.publishableKey = ApiConstants.stripePublishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessagingService.initialize();
  ApiService.init();
  SecureStorageService();
  await init();
  await SharedPref.init();
  final userId = SharedPref.getString(key: MySharedKeys.userId);
  safePrint(userId);
  safePrint(SharedPref.getString(key: MySharedKeys.type));
  final deviceTokenService = sl<DeviceTokenService>();
  String? deviceToken = await deviceTokenService.getDeviceToken();
  safePrint(deviceToken);
  DriverStatusListener driverStatusListener = DriverStatusListener(
    userId: userId!,
  );
  driverStatusListener.listenToDriverStatusChanges();
  runApp(
    AppEntryPoint(initialRoute: RoutingEndpoints.splash),
  );
}
