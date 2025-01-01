import '../../data/models/trip_model.dart';

abstract class TripRepoBase {
  Future<List<TripModel>> getTrips(String userId);
  Future<void> createTrip(TripModel tripModel);
  Future<bool> acceptTrip(TripModel tripModel);}