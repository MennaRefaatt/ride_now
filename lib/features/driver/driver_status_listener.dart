import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/enums/driver_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';

import 'driver_registration/data/models/driver_registration_model.dart';

class DriverStatusListener {
  final String userId;

  DriverStatusListener({required this.userId});

  void listenToDriverStatusChanges() {
    FirebaseFirestore.instance
        .collection("drivers")
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final driverStatus = data['driverStatus'];

        safePrint("Driver Status: $driverStatus");
        if (driverStatus == DriverStatus.accepted.name) {
          final driverModel = DriverRegistrationModel.fromJson(data);
          storeDriverDataInPrefs(driverModel);
        }
      } else {
        safePrint("Driver data not found for userId: $userId");
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

    safePrint("Driver ID stored: $driverId");
    safePrint("Driver Status stored: $driverStatus");
    safePrint("Driver Trip Status stored: $driverTripStatus");
    safePrint("Driver Name stored: $driverName");
    safePrint("Driver Picture stored: $driverPicture");

    if (driverId == true &&
        driverStatus == true &&
        driverTripStatus == true &&
        driverName == true &&
        driverPicture == true) {
      safePrint("Driver data successfully stored in SharedPreferences");
    } else {
      safePrint("Failed to store driver data in SharedPreferences");
    }
  }
}
