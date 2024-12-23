import 'package:geolocator/geolocator.dart';
import '../repo_base/repo_base.dart';

class GetUserLocationUseCase {
  final LocationRepository repository;

  GetUserLocationUseCase(this.repository);

  Future<Position> getCurrentLocation() async {
    return await repository.getCurrentLocation();
  }
}
