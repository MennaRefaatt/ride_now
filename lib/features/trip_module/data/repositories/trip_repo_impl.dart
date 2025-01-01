import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/trip_module/data/data_sources/trip_remote_ds.dart';
import 'package:ride_now/features/trip_module/data/models/trip_model.dart';

import '../../domain/repositories/trip_repo_base.dart';

class TripRepoImpl implements TripRepoBase {
  TripRemoteDS tripRemoteDS;
  TripRepoImpl(this.tripRemoteDS);

  @override
  Future<bool> acceptTrip(TripModel tripModel) async {
    final tripRef = await tripRemoteDS.acceptTrip(tripModel);
    safePrint(tripRef);
    return tripRef;
  }

  @override
  Future<TripModel> createTrip(TripModel tripModel) async {
    await tripRemoteDS.createTrip(tripModel);
    safePrint(tripModel);
    return tripModel;
  }

  @override
  Future<List<TripModel>> getTrips(String userId) async{
    final getTrips =await tripRemoteDS.getTrips(userId);
    safePrint("getTrips: $getTrips");
    return getTrips;
  }
}
