import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../core/helpers/enums/driver_trip_status.dart';
import '../../../../core/helpers/enums/trip_status.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../models/trip_model.dart';
import 'distance_helper/distance_helper.dart';

abstract class TripRemoteDS {
  Future<List<TripModel>> getTrips(String userId);
  Future<TripModel> getTripDetails(String tripId);
  Future<void> createTrip(TripModel tripModel);
  Future<void> acceptTrip(TripModel tripModel, DriverData driverData);
  Future<bool> cancelTripRequest(String tripId);
}

class TripRemoteDSImpl implements TripRemoteDS {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TripModel> getTripDetails(String tripId) async {
    try {
      final userId = SharedPref.getString(key: MySharedKeys.userId);
      safePrint("Fetching trips for passengerId: $userId");

      final getTheTrip = await FirebaseFirestore.instance
          .collection('trips')
          .where("passengerId", isEqualTo: userId)
          //.where("tripId", isEqualTo: tripId)
          .get();

      safePrint("Query result: ${getTheTrip.docs.length} documents found.");
      if (getTheTrip.docs.isNotEmpty) {
        final rawData = getTheTrip.docs.last.data();
        safePrint("Document data: $rawData");
        TripModel tripModel = TripModel.fromJson(rawData);
        safePrint("tripModel: $tripModel");
        return tripModel;
      } else {
        safePrint(
            "No trip found for passengerId: ${SharedPref.getString(key: MySharedKeys.userId)}");
        throw Exception("No trip found");
      }
    } catch (e) {
      throw Exception("Error getting trips: $e");
    }
  }

  @override
  Future<List<TripModel>> getTrips(String userId) async {
    try {
      final getTrips = await FirebaseFirestore.instance
          .collection('trips')
          .where("status", isEqualTo: TripStatus.pending.name)
          .orderBy('dateTime', descending: true)
          .limit(10)
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
      final userRef = FirebaseFirestore.instance.collection('users').doc(tripModel.passengerData.passengerId);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        final currentTripId = userDoc.data()?['currentTripId'];
        if (currentTripId != "none") {
          final tripRef = FirebaseFirestore.instance.collection('trips').doc(currentTripId);
          final tripDoc = await tripRef.get();
          if (tripDoc.exists) {
            final tripStatus = tripDoc.data()?['status'];
            if (tripStatus == TripStatus.accepted.name || tripStatus == TripStatus.pending.name) {
              throw Exception("You already have an active trip. Please wait for it to finish or cancel it before creating a new one.");
            } else {
              userRef.update({'currentTripId': 'none'});
              tripRef.update({'status': TripStatus.pending.name});
              tripRef.update(tripModel.toJson());
              safePrint("Trip updated successfully.");
            }
          }
        }
      } else {
        safePrint("User not found.");
        throw Exception("User not found.");
      }

      // Calculate distance and cost
      TripHelper tripHelper = TripHelper();
      String distance = await tripHelper.calculateDistance(tripModel.from, tripModel.to, unit: 'km');
      double distanceInKm = double.parse(distance.split(" ")[0]);
      double tripCost = tripHelper.calculateCost(distanceInKm);

      // Create the trip model with the new tripId
      final model = TripModel(
        driverData: DriverData(driverId: "", driverName: "", driverPhone: "", driverImage: "", driverLocation: ""),
        passengerData: PassengerData(
          passengerId: SharedPref.getString(key: MySharedKeys.userId)!,
          passengerName: SharedPref.getString(key: MySharedKeys.userName)!,
          passengerPhone: SharedPref.getString(key: MySharedKeys.phone)!,
        ),
        tripId: "",
        from: tripModel.from,
        to: tripModel.to,
        dateTime: tripModel.dateTime,
        price: tripCost.toString(),
        status: TripStatus.pending.name,
        distance: distance,
      );

      // Add the trip to Firestore and update tripId
      final tripRef = await FirebaseFirestore.instance.collection('trips').add(model.toJson());

      // Once the trip document is created, update the tripId
      await tripRef.update({'tripId': tripRef.id});

      // Update the user's currentTripId with the new tripId
      await userRef.update({'currentTripId': tripRef.id});
      safePrint("Trip created successfully.");
    } catch (e) {
      throw Exception("Error creating trip: $e");
    }
  }

  @override
  Future<void> acceptTrip(TripModel tripModel, DriverData driverData) async {
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
        final driverName = driver['personalInfo']['firstName'] +
            " " +
            driver['personalInfo']['lastName'];
        //final driverPhone = driver['personalInfo']['phone'];
        final driverImage = driver['personalInfo']['personalImage'];
        if (driverId != tripModel.driverData.driverId) {
          driverData = DriverData(
            driverId: driverId,
            driverName: driverName,
            driverPhone: "",
            driverImage: driverImage,
            driverLocation: "",
          );
          break;
        }
      }
      final tripRef =
          FirebaseFirestore.instance.collection('trips').doc(tripModel.tripId);
      await tripRef.update({
        'status': TripStatus.accepted.name,
        'driverId': driverData.driverId
      });
      await _firestore.collection('drivers').doc(driverData.driverId).update({
        'currentTripId': tripModel.tripId,
        'driverTripStatus': DriverTripStatus.onTrip.name,
      });

      safePrint("Trip $tripModel.tripId successfully accepted.");
    } catch (e) {
      throw Exception("Error accepting trip: $e");
    }
  }

  @override
  Future<bool> cancelTripRequest(String tripId) async {
    try {
      final userId = SharedPref.getString(key: MySharedKeys.userId);
      if (userId == null) {
        throw Exception("User ID not found in shared preferences.");
      }

      final tripRef =
          FirebaseFirestore.instance.collection('trips').doc(tripId);
      final tripDoc = await tripRef.get();

      if (!tripDoc.exists) {
        throw Exception("Trip not found.");
      }

      await tripRef.update({
        'status': TripStatus.canceled.name,
      });

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({
        'currentTripId': 'none',
      });

      safePrint("Trip $tripId successfully cancelled.");
      return true;
    } catch (e) {
      safePrint("Error cancelling trip: $e");
      throw Exception("Error cancelling trip: $e");
    }
  }
}
