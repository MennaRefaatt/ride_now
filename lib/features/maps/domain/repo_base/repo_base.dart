import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
abstract class LocationRepository {
  Future<Position> getCurrentLocation();
  Future<void> setMarkerPosition(LatLng location);
  Stream<Position> getRealTimeLocationUpdates();
}

