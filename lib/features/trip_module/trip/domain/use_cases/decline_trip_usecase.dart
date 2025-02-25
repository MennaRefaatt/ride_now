import 'package:ride_now/features/trip_module/trip/domain/repositories/trip_repo_base.dart';

class DeclineTripUseCase {
  final TripRepoBase tripRepoBase;

  DeclineTripUseCase(this.tripRepoBase);

  Future<void> call( String driverId,String tripId) async {
    return await tripRepoBase.declineTrip(driverId,tripId);
  }
}
