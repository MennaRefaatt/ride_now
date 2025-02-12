import 'package:ride_now/core/helpers/safe_print.dart';
import '../../domain/repositories/trip_repo_base.dart';
import '../data_sources/trip_remote_ds.dart';
import '../models/trip_model.dart';

class TripRepoImpl implements TripRepoBase {
  TripRemoteDS tripRemoteDS;
  TripRepoImpl(this.tripRemoteDS);

  @override
  Future<void> acceptTrip(TripModel tripModel,DriverData driverData) async {
    final tripRef = await tripRemoteDS.acceptTrip(tripModel,driverData);
    safePrint(driverData);
    return tripRef;
  }

  @override
  Future<TripModel> createTrip(TripModel tripModel) async {
    await tripRemoteDS.createTrip(tripModel);
    safePrint(tripModel);
    return tripModel;
  }

  @override
  Future<List<TripModel>> getTrips(String userId) async {
    final getTrips = await tripRemoteDS.getTrips(userId);
    safePrint("getTrips: $getTrips");
    return getTrips;
  }

  @override
  Future<TripModel> getTripDetails(String tripId) async {
    final getTrips = await tripRemoteDS.getTripDetails(tripId);
    safePrint("getTripDetails: $getTrips");
    return getTrips;
  }

  @override
  Future<bool> cancelTripRequest(String tripId) async {
    final tripRef = await tripRemoteDS.cancelTripRequest(tripId);
    safePrint(tripRef);
    return tripRef;
  }
}
