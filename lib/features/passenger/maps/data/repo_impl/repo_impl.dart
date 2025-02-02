import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/repo_base/repo_base.dart';
import '../data_source/data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeolocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<Position> getCurrentLocation() async{
    try {
      return await dataSource.getCurrentLocation();
    } catch (e) {
      throw Exception("Repository error: $e");
    }
  }

  @override
  Future<void> setMarkerPosition(LatLng location) async{
    try {
      return await dataSource.setMarkerPosition(location);
    } catch (e) {
      throw Exception("Marker error: $e");
    }
  }
  @override
  Stream<Position> getRealTimeLocationUpdates() {
    return dataSource.getRealTimeLocationUpdates();
  }
}
