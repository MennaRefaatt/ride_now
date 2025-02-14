import '../../../../../../core/helpers/safe_print.dart';
import '../../data/models/trip_model.dart';
import '../repositories/trip_repo_base.dart';

class AcceptTripUseCase {
  final TripRepoBase tripRepoBase;
  AcceptTripUseCase({required this.tripRepoBase});

  Future<void> call(TripModel tripModel,DriverData driverData) async {
    final tripRef = await tripRepoBase.acceptTrip(tripModel,driverData);
    safePrint(driverData);
    return tripRef;
  }
}