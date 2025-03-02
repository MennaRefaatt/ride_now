import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripTrackingArgs {
  final String fromAddress;
  final String toAddress;
  final String tripId;
  final String tripStatus;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final LatLng? driverLatLng;
  final String selectedCategory;
  TripTrackingArgs(
      {required this.fromAddress,
      required this.toAddress,
      required this.fromLatLng,
      required this.toLatLng,
      required this.driverLatLng,
      required this.tripStatus,
      required this.tripId,
      required this.selectedCategory});
}
