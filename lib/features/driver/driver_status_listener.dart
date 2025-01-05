import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_now/core/helpers/enums/driver_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'driver_registration/data/models/driver_registration_model.dart';

class DriverStatusListener {
  final String userId;

  DriverStatusListener({required this.userId});

  void listenToDriverStatusChanges() {
    if (userId.isEmpty) {
      safePrint("Error: userId is empty. Cannot listen to driver status.");
      return;
    }

    FirebaseFirestore.instance
        .collection("drivers")
        .doc(userId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final driverStatus = data['driverStatus'];

        safePrint("Driver Status: $driverStatus");

        if (driverStatus == DriverStatus.accepted.name) {
          try {
            Position position = await _getCurrentLocation();
            final location = {
              'latitude': position.latitude,
              'longitude': position.longitude,
            };
            await FirebaseFirestore.instance
                .collection("drivers")
                .doc(userId)
                .update({
              'location': location,
            });

            storeDriverDataInPrefs(DriverRegistrationModel.fromJson(data));
            safePrint("Driver location updated: $location");
          } catch (e) {
            safePrint("Error fetching location: $e");
          }
        }
      }
    });
  }

  void storeDriverDataInPrefs(DriverRegistrationModel driverModel) {
    safePrint("Storing driver data for ${driverModel.driverId}");

    final driverId = SharedPref.setString(
        key: MySharedKeys.driverId, value: driverModel.driverId);
    final driverStatus = SharedPref.setString(
        key: MySharedKeys.driverStatus, value: driverModel.driverStatus);
    final driverTripStatus = SharedPref.setString(
        key: MySharedKeys.driverTripStatus,
        value: driverModel.driverTripStatus);
    final driverName = SharedPref.setString(
        key: MySharedKeys.driverName,
        value:
            "${driverModel.personalInfo.firstName} ${driverModel.personalInfo.lastName}");
    final driverPicture = SharedPref.setString(
        key: MySharedKeys.driverPicture,
        value: driverModel.personalInfo.personalImage);
    final carNumber = SharedPref.setString(
        key: MySharedKeys.carNumber,
        value: driverModel.vehicleInfo.plateNumber);
    final carColor = SharedPref.setString(
        key: MySharedKeys.carColor,
        value: driverModel.vehicleInfo.vehicleColor);
    final carModel = SharedPref.setString(
        key: MySharedKeys.carModel,
        value: driverModel.vehicleInfo.vehicleModel);

    safePrint("Driver ID stored: $driverId");
    safePrint("Driver Status stored: $driverStatus");
    safePrint("Driver Trip Status stored: $driverTripStatus");
    safePrint("Driver Name stored: $driverName");
    safePrint("Driver Picture stored: $driverPicture");
    safePrint("Car Number stored: $carNumber");
    safePrint("Car Color stored: $carColor");
    safePrint("Car Model stored: $carModel");

    if (driverId == true &&
        driverStatus == true &&
        driverTripStatus == true &&
        driverName == true &&
        driverPicture == true &&
        carNumber == true &&
        carColor == true &&
        carModel == true) {
      safePrint("Driver data successfully stored in SharedPreferences");
    } else {
      safePrint("Failed to store driver data in SharedPreferences");
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is permanently denied');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
