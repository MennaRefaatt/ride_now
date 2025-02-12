import '../../data/models/trip_model.dart';
import '../repositories/trip_repo_base.dart';

class CreateTripUseCase {
  final TripRepoBase tripRepoBase;
  CreateTripUseCase({required this.tripRepoBase});

  Future<void> call(TripModel tripModel) async {
    await tripRepoBase.createTrip(tripModel);
  }
}