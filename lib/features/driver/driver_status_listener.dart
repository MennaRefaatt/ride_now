import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ride_now/core/helpers/enums/driver_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
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
            final location = DriverLocation(
                latitude: position.latitude,
                longitude: position.longitude);
            await FirebaseFirestore.instance
                .collection("drivers")
                .doc(userId)
                .update({
              'location': location,
            });

            await storeDriverDataInPrefs(
                DriverRegistrationModel.fromJson(data));
            safePrint("Driver location updated: $location");
          } catch (e) {
            safePrint("Error fetching location: $e");
          }
        }
      }
    });
  }

  Future<void> storeDriverDataInPrefs(
      DriverRegistrationModel driverModel) async {
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
