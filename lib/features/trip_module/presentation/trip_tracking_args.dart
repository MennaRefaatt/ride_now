import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripTrackingArgs {
  final String fromAddress;
  final String toAddress;
  final String tripId;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final LatLng driverLatLng;
  TripTrackingArgs(
      {required this.fromAddress,
      required this.toAddress,
      required this.fromLatLng,
      required this.toLatLng,
      required this.driverLatLng,
      required this.tripId});
}
