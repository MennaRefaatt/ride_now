import '../../data/models/trip_model.dart';
import '../repositories/trip_repo_base.dart';

class GetTripsUseCase {
  final TripRepoBase tripRepoBase;
  GetTripsUseCase({required this.tripRepoBase});

  Future<List<TripModel>> call(String userId) async {
    final trips = await tripRepoBase.getTrips(userId);
    return trips;
  }
}