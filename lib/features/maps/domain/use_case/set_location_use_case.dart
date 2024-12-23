import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repo_base/repo_base.dart';
class SetLocationUseCase {
  final LocationRepository repository;

  SetLocationUseCase(this.repository);

  Future<void> setLocation(LatLng location) async {
    await repository.setMarkerPosition(location);
  }
}
