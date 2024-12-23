import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/helpers/safe_print.dart';

abstract class GeolocationDataSource {
  Future<Position> getCurrentLocation();
  Stream<Position> getRealTimeLocationUpdates();
  Future<void> setMarkerPosition(LatLng location);
}

class GeolocationDataSourceImpl implements GeolocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }
    throw Exception("Location permission denied");
  }

  @override
  Future<void> setMarkerPosition(LatLng location) async {
    if (location.latitude != 0.0 && location.longitude != 0.0) {
      safePrint(location.toString());
      return;
    }
    return;
  }
  @override
  Stream<Position> getRealTimeLocationUpdates() {
    final positionStream = Geolocator.getPositionStream();
    return positionStream;
  }
}
