import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../../../core/helpers/safe_print.dart';

import '../../../../../core/helpers/enums/driver_trip_status.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
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
      if (tripId.isEmpty) {
        throw Exception('Trip ID is empty');
      }

      final getTheTrip = await _firestore.collection('trips').doc(tripId).get();

      if (getTheTrip.exists) {
        final rawData = getTheTrip.data() as Map<String, dynamic>;
        safePrint("Document data: $rawData");
        TripModel tripModel = TripModel.fromJson(rawData);
        safePrint("tripModel: $tripModel");
        safePrint("driverData: ${tripModel.driverData}");
        safePrint("driverData: ${tripModel.driverData.carColor}");
        safePrint("passengerData: ${tripModel.passengerData}");
        safePrint("status: ${tripModel.status}");
        return tripModel;
      } else {
        safePrint("No trip found for tripId: $tripId");
        throw Exception("No trip found");
      }
    } catch (e) {
      safePrint("Error getting trip details: $e");
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
        safePrint("driverData: ${data['driverData']}");
        safePrint("passengerData: ${data['passengerData']}");
        return TripModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception("Error getting trips: $e");
    }
  }

  @override
  Future<void> createTrip(TripModel tripModel) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(tripModel.passengerData.passengerId);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        final currentTripId = userDoc.data()?['currentTripId'];
        if (currentTripId != "none") {
          final tripRef =
              FirebaseFirestore.instance.collection('trips').doc(currentTripId);
          final tripDoc = await tripRef.get();
          if (tripDoc.exists) {
            final tripStatus = tripDoc.data()?['status'];
            if (tripStatus == TripStatus.accepted.name ||
                tripStatus == TripStatus.pending.name) {
              tripRef.update({'status': TripStatus.canceled.name});
              userRef.update({'currentTripId': 'none'});
            }
          }
        }
      } else {
        safePrint("User not found.");
        throw Exception("User not found.");
      }

      TripHelper tripHelper = TripHelper();
      LatLng fromCoordinates = tripModel.fromLatLng;
      LatLng toCoordinates = tripModel.toLatLng;

      String distance = await tripHelper
          .calculateDistance(fromCoordinates, toCoordinates, unit: 'km');
      String estimatedTime = await tripHelper.calculateEstimatedArrivalTime(
          fromCoordinates, toCoordinates, 30);
      double calculatedCost =
          tripHelper.calculateCost(double.parse(distance.split(" ")[0]));
      String formattedCost = tripHelper.formatCost(calculatedCost);

      final model = TripModel(
        fromLatLng: fromCoordinates,
        toLatLng: toCoordinates,
        paymentMethod: tripModel.paymentMethod,
        paymentStatus: StripePaymentStatus.holding.name,
        estimatedTime: estimatedTime,
        moreThan4Passengers: tripModel.moreThan4Passengers,
        comment: tripModel.comment,
        driverData: DriverData(
          driverId: "",
          driverName: "",
          driverPhone: "",
          driverImage: "",
          carColor: "",
          carModel: "",
          carNumber: "",
          driverToken: "",
          driverLocation: LatLng(0, 0),
        ),
        passengerData: PassengerData(
          passengerId: SharedPref.getString(key: MySharedKeys.userId)!,
          passengerName: SharedPref.getString(key: MySharedKeys.userName)!,
          passengerPhone: SharedPref.getString(key: MySharedKeys.phone)!,
          passengerToken: SharedPref.getString(key: MySharedKeys.deviceToken)!,
        ),
        tripId: "",
        from: tripModel.from,
        to: tripModel.to,
        dateTime: tripModel.dateTime,
        price: formattedCost,
        status: TripStatus.pending.name,
        distance: distance,
      );

      final tripRef = await FirebaseFirestore.instance
          .collection('trips')
          .add(model.toJson());
      await tripRef.update({'tripId': tripRef.id});
      SharedPref.setString(key: MySharedKeys.currentTripId, value: tripRef.id);
      await userRef.update({'currentTripId': tripRef.id});
      safePrint("Trip created successfully.");
    } catch (e) {
      throw Exception("Error creating trip: $e");
    }
  }

  @override
  Future<void> acceptTrip(TripModel tripModel, DriverData driverData) async {
    try {
      final tripRef =
          FirebaseFirestore.instance.collection('trips').doc(tripModel.tripId);

      final availableDriversSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .where("driverTripStatus",
              whereIn: [DriverTripStatus.available.name]).get();
      final availableDrivers = availableDriversSnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      for (var driver in availableDrivers) {
        final driverId = driver['driverId'];
        final driverName = driver['personalInfo']['firstName'] +
            "" +
            driver['personalInfo']['lastName'];
        final driverPhone = driver['personalInfo']['phone'];
        final diverLat = driver['location']['latitude'];
        final diverLong = driver['location']['longitude'];
        final driverImage = driver['personalInfo']['personalImage'];
        final carColor = driver['vehicleInfo']['vehicleColor'];
        final carModel = driver['vehicleInfo']['vehicleModel'];
        final carNumber = driver['vehicleInfo']['plateNumber'];
        if (driverId != tripModel.driverData.driverId) {
          driverData = DriverData(
            driverId: driverId,
            driverName: driverName,
            driverPhone: driverPhone,
            driverImage: driverImage,
            driverToken: SharedPref.getString(key: MySharedKeys.deviceToken)!,
            driverLocation: LatLng(diverLat, diverLong),
            carColor: carColor,
            carModel: carModel,
            carNumber: carNumber,
          );
          break;
        }
      }
      safePrint("Driver data: $driverData");
      await tripRef.update({
        'status': TripStatus.accepted.name,
        "driverData": driverData.toJson(),
        "paymentStatus": StripePaymentStatus.succeeded.name
      });
      await _firestore.collection('drivers').doc(driverData.driverId).update({
        'currentTripId': tripModel.tripId,
        'driverTripStatus': DriverTripStatus.onTrip.name,
      });
      await _firestore.collection('users').doc(driverData.driverId).update({
        'currentTripId': tripModel.tripId,
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
      final driverRef = FirebaseFirestore.instance
          .collection('drivers')
          .doc(tripDoc.data()!['driverData']['driverId']);
      await driverRef.update({
        "driverTripStatus": DriverTripStatus.available.name,
        "currentTripId": "none",
      });
      await _firestore
          .collection('users')
          .doc(tripDoc.data()!['driverData']['driverId'])
          .update({
        'currentTripId': "none",
      });

      safePrint("Trip $tripId successfully cancelled.");
      return true;
    } catch (e) {
      safePrint("Error cancelling trip: $e");
      throw Exception("Error cancelling trip: $e");
    }
  }
}
