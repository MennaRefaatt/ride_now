import '../repositories/trip_repo_base.dart';

class CompleteTripUseCase {
  final TripRepoBase tripRepoBase;

  CompleteTripUseCase(this.tripRepoBase);
  Future<void> call(String tripId) async {
    return await tripRepoBase.completeTrip(tripId);
  }
}
