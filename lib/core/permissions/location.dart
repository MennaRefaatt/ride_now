import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

class LocationPermissionHandler {
  /// Requests location permission and ensures the user enables location services
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      safePrint("❌ Location services are disabled.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      safePrint("❌ Location permission permanently denied. Open settings.");
      openAppSettings();
      return false;
    }

    if (permission == LocationPermission.denied) {
      safePrint("⚠️ Location permission denied.");
      return false;
    }

    safePrint("✅ Location permission granted.");
    return true;
  }
}
