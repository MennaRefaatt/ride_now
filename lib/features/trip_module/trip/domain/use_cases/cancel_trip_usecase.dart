import '../repositories/trip_repo_base.dart';

class CancelTripUseCase {
  final TripRepoBase tripRepoBase;

  CancelTripUseCase(this.tripRepoBase);
  Future<bool> call(String tripId) async {
    return await tripRepoBase.cancelTripRequest(tripId);
  }
}
