import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/helpers/safe_print.dart';
abstract class GeolocationDataSource {
  Future<Position> getCurrentLocation();
  Stream<Position> getRealTimeLocationUpdates();
  Future<void> setMarkerPosition(LatLng location);
}

class GeolocationDataSourceImpl implements GeolocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied.");
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best
      );
    } catch (e) {
      throw Exception("Failed to get location: $e");
    }
  }

  @override
  Future<void> setMarkerPosition(LatLng location) async {
    if (location.latitude != 0.0 && location.longitude != 0.0) {
      safePrint(location.toString());
    }
  }

  @override
  Stream<Position> getRealTimeLocationUpdates() {
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 10
        )
    ).handleError((error) => throw Exception("Location stream error: $error"));
  }
}
