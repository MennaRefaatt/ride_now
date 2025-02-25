import '../../data/models/trip_model.dart';

abstract class TripRepoBase {
  Future<List<TripModel>> getTrips(String userId);

  Future<void> createTrip(TripModel tripModel);

  Future<void> acceptTrip(TripModel tripModel,DriverData driverData);

  Future<TripModel> getTripDetails(String tripId);

  Future<bool> cancelTripRequest(String tripId);

  Future<void> completeTrip(String tripId);
  Future<void> declineTrip( String driverId,String tripId);
}
