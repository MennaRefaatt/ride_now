import '../../../../core/helpers/safe_print.dart';
import '../../data/models/trip_model.dart';
import '../repositories/trip_repo_base.dart';

class AcceptTripUseCase {
  final TripRepoBase tripRepoBase;
  AcceptTripUseCase({required this.tripRepoBase});

  Future<bool> call(TripModel tripModel) async {
    final tripRef = await tripRepoBase.acceptTrip(tripModel);
    safePrint(tripRef);
    return tripRef;
  }
}