import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class TripHelper {
  static const double costPerKm = 10.0;  // سعر ثابت لكل كيلومتر (على سبيل المثال)
  // Function to calculate distance between two locations
  Future<String> calculateDistance(String from, String to, {String unit = 'km'}) async {
    try {
      // Get the coordinates (latitude and longitude) for the 'from' and 'to' locations
      List<Location> fromLocations = await locationFromAddress(from);
      List<Location> toLocations = await locationFromAddress(to);

      // Check if coordinates are available
      if (fromLocations.isNotEmpty && toLocations.isNotEmpty) {
        double fromLatitude = fromLocations.first.latitude;
        double fromLongitude = fromLocations.first.longitude;
        double toLatitude = toLocations.first.latitude;
        double toLongitude = toLocations.first.longitude;

        // Calculate distance using Geolocator (returns distance in meters)
        double distanceInMeters = Geolocator.distanceBetween(
          fromLatitude,
          fromLongitude,
          toLatitude,
          toLongitude,
        );

        // Convert distance to requested unit (km or m)
        if (unit == 'km') {
          // Convert from meters to kilometers
          return (distanceInMeters / 1000).toStringAsFixed(2) + ' km';
        } else if (unit == 'm') {
          // Return the distance in meters
          return distanceInMeters.toStringAsFixed(2) + ' m';
        } else {
          // Default to kilometers if the unit is unknown
          return (distanceInMeters / 1000).toStringAsFixed(2) + ' km';
        }
      } else {
        throw Exception("Unable to find coordinates for one of the locations.");
      }
    } catch (e) {
      throw Exception("Error calculating distance: $e");
    }
  }
  double calculateCost(double distanceInKm) {
      if (distanceInKm <= 0) {
        throw Exception("Invalid distance value");
      }
      return costPerKm * distanceInKm;
  }
}
