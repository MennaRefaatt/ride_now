import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/firebase_options.dart';
import 'core/components/app_entry_point.dart';
import 'core/di/di.dart';
import 'core/helpers/safe_print.dart';
import 'core/helpers/secure_storage/secure_storage.dart';
import 'core/helpers/shared_pref.dart';
import 'core/helpers/shared_pref_keys.dart';
import 'core/services/network/api_service.dart';

Future<void> main() async {
  // await PaymobPayment.instance.initialize(
  //   apiKey: PaymentConstants.apiKey,
  //   integrationID: PaymentConstants.integrationId,
  //   iFrameID: PaymentConstants.iFrameId,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ApiService.init();
  await init();
  await SharedPref.init();
  safePrint(SharedPref.getString(key: MySharedKeys.userId));
  SecureStorageService();
  runApp(
    const AppEntryPoint(),
  );
}
