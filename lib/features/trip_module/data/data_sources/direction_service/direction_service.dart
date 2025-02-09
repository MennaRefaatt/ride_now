import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ride_now/core/services/network/api_constants.dart';
import '../../../../../core/helpers/safe_print.dart';

class DirectionService {
  final openRouteServiceApiKey = ApiConstants.openRouteServiceApiKey;
  final openRouteServiceBaseUrl = ApiConstants.openRouteServiceBaseUrl;

  final _routeCache = <String, List<LatLng>>{};

  Future<List<LatLng>> getRouteCoordinates(
    LatLng origin,
    LatLng destination, {
    bool useCache = true,
  }) async {
    final cacheKey = '${origin.latitude},${origin.longitude}_'
        '${destination.latitude},${destination.longitude}';

    if (useCache && _routeCache.containsKey(cacheKey)) {
      return _routeCache[cacheKey]!;
    }

    final coordinates = await _fetchRouteWithRetry(origin, destination);
    _routeCache[cacheKey] = coordinates;
    return coordinates;
  }

  Future<List<LatLng>> _fetchRouteWithRetry(
      LatLng origin,
      LatLng destination,
      ) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final response = await http.get(_buildUrl(origin, destination));
        if (response.statusCode == 200) return _parseResponse(response);
        if (response.statusCode == 429) await _handleRateLimit();
        retryCount++;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          safePrint('Error fetching directions: Exception: Failed after $maxRetries attempts');
          await _handleRateLimit();
          rethrow;
        }
      }
    }
    throw Exception('Failed after $maxRetries attempts');
  }


  Uri _buildUrl(LatLng origin, LatLng destination) =>
      Uri.parse('$openRouteServiceBaseUrl$openRouteServiceApiKey&'
          'start=${origin.longitude},${origin.latitude}&'
          'end=${destination.longitude},${destination.latitude}');

  List<LatLng> _parseResponse(http.Response response) {
    final data = json.decode(response.body);
    return (data['features'][0]['geometry']['coordinates'] as List)
        .map((coord) => LatLng(coord[1], coord[0]))
        .toList();
  }

  Future<void> _handleRateLimit() async {
    const int delay = 5;
    safePrint('Rate limited. Retrying in $delay seconds...');
    await Future.delayed(const Duration(seconds: delay));
  }

}
