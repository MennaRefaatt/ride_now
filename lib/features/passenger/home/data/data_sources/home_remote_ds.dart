import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';

import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../models/category_model.dart';

abstract class HomeRemoteDS {
  Future<List<CategoryModel>> getCategories();
  Future<List<TripModel>> getRecentTrips();
}

class HomeRemoteDSImpl implements HomeRemoteDS {
  @override
  Future<List<CategoryModel>> getCategories() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('categories').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        safePrint(data);
        return CategoryModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception("Error getting categories: $e");
    }
  }

  @override
  Future<List<TripModel>> getRecentTrips() async {
    final firestore = FirebaseFirestore.instance;
    final userId = SharedPref.getString(key: MySharedKeys.userId);
    try {
      final querySnapshot = await firestore
          .collection('trips')
          .where('passengerData.passengerId', isEqualTo: userId)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        safePrint('Raw trip data: $data');

        final latLngData = data['toLatLng'];
        safePrint('LatLng Data: $latLngData');

        double lat = 0.0;
        double lng = 0.0;

        if (latLngData != null && latLngData is Map) {
          lat = latLngData['latitude'] ?? 0.0;
          lng = latLngData['longitude'] ?? 0.0;
        }

        final toLatLng = LatLng(lat, lng);
        safePrint('Parsed LatLng: $toLatLng');

        return TripModel.fromJson({
          ...data,
          'toLatLng': toLatLng,
        });
      }).toList();
    } catch (e) {
      throw Exception("Error getting recent trips: $e");
    }
  }
}
