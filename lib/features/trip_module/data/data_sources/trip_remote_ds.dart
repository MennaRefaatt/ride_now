import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../core/helpers/enums/driver_trip_status.dart';
import '../../../../core/helpers/enums/trip_status.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../models/trip_model.dart';

abstract class TripRemoteDS {
  Future<List<TripModel>> getTrips(String userId);
  Future<void> createTrip(TripModel tripModel);
  Future<bool> acceptTrip(TripModel tripModel);
}

class TripRemoteDSImpl implements TripRemoteDS {
  @override
  Future<List<TripModel>> getTrips(String userId) async {
    try {
      final getTrips = await FirebaseFirestore.instance
          .collection('trips')
          .get();
      return getTrips.docs.map((doc) {
        final data = doc.data();
        safePrint("data: $data");
        return TripModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception("Error getting trips: $e");
    }
  }

  @override
  Future<void> createTrip(TripModel tripModel) async {
    try {
      final availableDriversSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .where("driverTripStatus", whereIn: [
        DriverTripStatus.available.name,
        DriverTripStatus.online.name
      ]).get();
      final availableDrivers = availableDriversSnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      for (var driver in availableDrivers) {
        final driverId = driver['driverId'];
        final model = TripModel(
          driverId: "",
          tripId: "",
          passengerId: tripModel.passengerId,
          from: tripModel.from,
          to: tripModel.to,
          dateTime: DateTime.now(),
          price: tripModel.price,
          status: TripStatus.pending.name,
          passengerName: SharedPref.getString(key: MySharedKeys.userName)!,
          distance: tripModel.distance
        );
        final tripRef = await FirebaseFirestore.instance
            .collection('trips')
            .add(model.toJson());

        await tripRef.update({
          'tripId': tripRef.id,
        });
      }
    } catch (e) {
      throw Exception("Error creating trip: $e");
    }
  }

  @override
  Future<bool> acceptTrip(TripModel tripModel) async {
    try {
      final tripRef =
          FirebaseFirestore.instance.collection('trips').doc(tripModel.tripId);
      await tripRef.update(
          {'status': TripStatus.accepted.name, 'driverId': tripModel.driverId});
      return true;
    } catch (e) {
      throw Exception("Error accepting trip: $e");
    }
  }
}
