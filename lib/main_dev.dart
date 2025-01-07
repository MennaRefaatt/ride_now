import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/driver/driver_status_listener.dart';
import 'package:ride_now/firebase_options.dart';
import 'core/components/app_entry_point.dart';
import 'core/di/di.dart';
import 'core/helpers/safe_print.dart';
import 'core/helpers/secure_storage/secure_storage.dart';
import 'core/helpers/shared_pref.dart';
import 'core/helpers/shared_pref_keys.dart';
import 'core/services/network/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ApiService.init();
  await init();
  await SharedPref.init();
  final userId = SharedPref.getString(key: MySharedKeys.userId);
  safePrint(userId);
  safePrint(SharedPref.getString(key: MySharedKeys.userName));
  safePrint(SharedPref.getString(key: MySharedKeys.picture));
  safePrint(SharedPref.getString(key: MySharedKeys.type));
  DriverStatusListener driverStatusListener = DriverStatusListener(
    userId: userId!,
  );
  driverStatusListener.listenToDriverStatusChanges();
  SecureStorageService();

  runApp(
    AppEntryPoint(initialRoute: RoutingEndpoints.splash),
  );
}
