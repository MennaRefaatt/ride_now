import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/components/app_entry_point.dart';
import 'core/di/di.dart';
import 'core/helpers/secure_storage/secure_storage.dart';
import 'core/helpers/shared_pref.dart';
import 'core/services/fcm/firebase_messaging_service.dart';
import 'core/services/network/api_service.dart';
import 'core/services/routing/routing_endpoints.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env.staging");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  await SharedPref.init();
  FirebaseMessagingService.initialize();
  ApiService.init();
  SecureStorageService();
  runApp(const AppEntryPoint(initialRoute:  RoutingEndpoints.splash));

}