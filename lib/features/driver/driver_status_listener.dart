import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_now/core/helpers/enums/driver_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/secure_storage/secure_storage.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/driver/subscribe_driver_to_topic.dart';
import '../../core/helpers/secure_storage/secure_keys.dart';
import '../../core/helpers/shared_pref_keys.dart';
import '../../core/services/f_c_m_service/firebase_messaging_service.dart';
import 'driver_registration/data/models/driver_registration_model.dart';

class DriverStatusListener {
  final String userId;

  DriverStatusListener({required this.userId});

  void listenToDriverStatusChanges() {
    if (userId.isEmpty) {
      safePrint("Error: userId is empty. Cannot listen to driver status.");
      return;
    }
    final previousStatus =
        SharedPref.getString(key: MySharedKeys.previousDriverStatus);
    safePrint("Previous Status: $previousStatus");

    FirebaseFirestore.instance
        .collection("drivers")
        .doc(userId)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final driverStatus = data['driverStatus'];

        safePrint("Driver Status: $driverStatus");

        if (driverStatus == DriverStatus.accepted.name &&
            previousStatus != DriverStatus.accepted.name) {
          try {
            await sendNotification(
              title: "You have been Accepted",
              body: "You are now available for a trip.",
              topic: "drivers",
            );
            await subscribeDriverToTopic(data['driverToken']);

            Position position = await _getCurrentLocation();
            final location = DriverLocation(
                latitude: position.latitude, longitude: position.longitude);

            String? newToken = await FirebaseMessaging.instance.getToken();
            if (newToken == null) {
              safePrint("Error: FCM token is null.");
            }

            await FirebaseFirestore.instance
                .collection("drivers")
                .doc(userId)
                .update({
              'location': location.toJson(),
              if (newToken != null) 'driverToken': newToken,
            });
            await storeDriverDataInPrefs(
                DriverRegistrationModel.fromJson(data), newToken);
            safePrint("Firestore: Driver location and token updated.");
            SharedPref.setString(
                key: MySharedKeys.previousDriverStatus,
                value: DriverStatus.accepted.name);
          } catch (e) {
            safePrint("Error fetching location or updating Firestore: $e");
          }
        }
      }
    });
  }

  Future<void> storeDriverDataInPrefs(
      DriverRegistrationModel driverModel, String? driverToken) async {
    safePrint("Storing driver data for ${driverModel.driverId}");

    await SharedPref.storeDriverData(
      driverId: driverModel.driverId,
      driverStatus: driverModel.driverStatus,
      driverTripStatus: driverModel.driverTripStatus,
      driverName:
          "${driverModel.personalInfo.firstName} ${driverModel.personalInfo.lastName}",
      driverPicture: driverModel.personalInfo.personalImage,
      carNumber: driverModel.vehicleInfo.plateNumber,
      carColor: driverModel.vehicleInfo.vehicleColor,
      carModel: driverModel.vehicleInfo.vehicleModel,
      latitude: driverModel.location.latitude,
      longitude: driverModel.location.longitude,
    );

    if (driverToken != null) {
      await SecureStorageService.writeData(
        SecureKeys.deviceToken,
        driverToken,
      );
      safePrint("Local Storage: Driver token updated.");
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is permanently denied');
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission is denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
