import '../../data/models/trip_model.dart';
import '../repositories/trip_repo_base.dart';

class GetTripDetailsUseCase {
  final TripRepoBase tripRepoBase;
  GetTripDetailsUseCase({required this.tripRepoBase});

  Future<TripModel> call(String tripId) async {
    final trip = await tripRepoBase.getTripDetails(tripId);
    return trip;
  }
}
