import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_now/core/services/network/api_constants.dart';

class DirectionService {
  final googleApi = ApiConstants.googleApiKey;

  // Fetch route coordinates using Google Directions API
  Future<List<LatLng>> getRouteCoordinates(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApi'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;
      final polylinePoints = routes.isNotEmpty
          ? routes[0]['legs'][0]['steps'] as List
          : [];

      List<LatLng> points = [];
      for (var step in polylinePoints) {
        final lat = step['end_location']['lat'];
        final lng = step['end_location']['lng'];
        points.add(LatLng(lat, lng));
      }
      return points;
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
