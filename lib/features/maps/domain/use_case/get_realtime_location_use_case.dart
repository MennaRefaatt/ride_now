import 'package:geolocator/geolocator.dart';
import '../repo_base/repo_base.dart';

class GetRealtimeLocationUseCase {
  final LocationRepository repository;

  GetRealtimeLocationUseCase(this.repository);

  Stream<Position> getRealTimeLocationUpdates() {
    return repository.getRealTimeLocationUpdates();
  }
}
