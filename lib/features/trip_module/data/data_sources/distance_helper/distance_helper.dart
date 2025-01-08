import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripHelper {
  /// Calculates the distance between two coordinates (lat1, lon1) and (lat2, lon2).
  /// Returns the distance as a string in the specified unit ('km' or 'miles').
  Future<String> calculateDistance(LatLng from, LatLng to, {String unit = 'km'}) async {
    const double radiusOfEarthKm = 6371.0; // Radius of Earth in kilometers
    const double radiusOfEarthMiles = 3958.8; // Radius of Earth in miles

    final double lat1Rad = radians(from.latitude);
    final double lon1Rad = radians(from.longitude);
    final double lat2Rad = radians(to.latitude);
    final double lon2Rad = radians(to.longitude);

    // Haversine formula
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    final double a = pow(sin(dLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Choose the correct radius
    final double radius = unit == 'miles' ? radiusOfEarthMiles : radiusOfEarthKm;

    final double distance = radius * c;

    return "${distance.toStringAsFixed(2)} $unit";
  }

  /// Converts degrees to radians.
  double radians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Example function to calculate trip cost based on distance.
  double calculateCost(double distanceInKm, {double ratePerKm = 1.5}) {
    return distanceInKm * ratePerKm;
  }
}
