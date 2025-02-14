import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';

import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
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

        final fromLatLngData = data['fromLatLng'] as Map?;
        final toLatLngData = data['toLatLng'] as Map?;
        double fromLat = fromLatLngData?['latitude'] ?? 0.0;
        double fromLng = fromLatLngData?['longitude'] ?? 0.0;
        double toLat = toLatLngData?['latitude'] ?? 0.0;
        double toLng = toLatLngData?['longitude'] ?? 0.0;
        return TripModel.fromJson({
          ...data,
          'fromLatLng': LatLng(fromLat, fromLng),
          'toLatLng': LatLng(toLat, toLng),
        });
      }).toList();
    } catch (e) {
      throw Exception("Error getting recent trips: $e");
    }
  }
}
