import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../domain/repo_base/repo_base.dart';
import '../data_source/data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeolocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<Position> getCurrentLocation() async{
    final position = await dataSource.getCurrentLocation();
    try {
      safePrint(position.toString());
     return position;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> setMarkerPosition(LatLng location) async{
   final position =  await dataSource.setMarkerPosition(location);
    try {
      return position;
    } catch (e) {
      return Future.error(e);
    }
  }
  @override
  Stream<Position> getRealTimeLocationUpdates() {
    return dataSource.getRealTimeLocationUpdates();
  }
}
