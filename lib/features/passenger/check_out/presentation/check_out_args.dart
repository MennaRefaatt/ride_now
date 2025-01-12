import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckOutArgs {
  final String fromAddress;
  final String toAddress;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  CheckOutArgs(
      {required this.fromLatLng,
      required this.toLatLng,
      required this.fromAddress,
      required this.toAddress});
}
