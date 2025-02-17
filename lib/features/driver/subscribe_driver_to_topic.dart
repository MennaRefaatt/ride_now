import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/helpers/safe_print.dart';

Future<void> subscribeDriverToTopic(String driverToken) async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic('drivers');
    safePrint("Driver subscribed to topic: drivers");
  } catch (e) {
    safePrint("Error subscribing driver to topic: $e");
  }
}
