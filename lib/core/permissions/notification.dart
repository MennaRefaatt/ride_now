import 'package:permission_handler/permission_handler.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

Future<void> requestNotificationPermission() async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    safePrint("✅ Notification permission granted");
  } else if (status.isDenied) {
    safePrint("⚠️ Notification permission denied");
  } else if (status.isPermanentlyDenied) {
    safePrint("❌ Notification permission permanently denied. Open settings.");
    openAppSettings();
  }
}
