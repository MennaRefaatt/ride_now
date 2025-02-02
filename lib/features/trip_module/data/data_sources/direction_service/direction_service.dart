import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_now/core/services/network/api_constants.dart';

import '../../../../../core/helpers/safe_print.dart';

class DirectionService {
  final openRouteServiceApiKey = ApiConstants.openRouteServiceApiKey;
  final openRouteServiceBaseUrl = ApiConstants.openRouteServiceBaseUrl;
  Future<List<LatLng>> getRouteCoordinates(
      LatLng origin, LatLng destination) async {
    final url = Uri.parse(
        '$openRouteServiceBaseUrl$openRouteServiceApiKey&start=${origin.longitude},${origin.latitude}&end=${destination.longitude},${destination.latitude}');

    final response = await http.get(url);
    safePrint('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates =
          data['features'][0]['geometry']['coordinates'] as List;
      List<LatLng> points = [];
      for (var coordinate in coordinates) {
        points.add(LatLng(
            coordinate[1], coordinate[0]));
      }
      return points;
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
