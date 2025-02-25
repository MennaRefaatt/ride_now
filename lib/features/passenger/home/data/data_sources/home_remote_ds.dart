import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/trip_status.dart';
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
    final userRole = SharedPref.getString(key: MySharedKeys.type);

    try {
      Query query = firestore.collection('trips')
          .where('status', isEqualTo: TripStatus.completed.name);

      if (userRole == 'driver') {
        query = query.where('driverData.driverId', isEqualTo: userId);
      } else {
        query = query.where('passengerData.passengerId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        safePrint("No trips found.");
        return [];
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          safePrint("Null trip data found.");
          return null;
        }

        safePrint("Trip data: $data");

        final fromLatLngData = (data['fromLatLng'] as Map<String, dynamic>?) ?? {};
        final toLatLngData = (data['toLatLng'] as Map<String, dynamic>?) ?? {};

        double fromLat = (fromLatLngData['latitude'] as num?)?.toDouble() ?? 0.0;
        double fromLng = (fromLatLngData['longitude'] as num?)?.toDouble() ?? 0.0;
        double toLat = (toLatLngData['latitude'] as num?)?.toDouble() ?? 0.0;
        double toLng = (toLatLngData['longitude'] as num?)?.toDouble() ?? 0.0;

        return TripModel.fromJson({
          ...(data),
          'fromLatLng': LatLng(fromLat, fromLng),
          'toLatLng': LatLng(toLat, toLng),
        });
      }).whereType<TripModel>().toList();
    } catch (e) {
      safePrint("Error getting recent trips: $e");
      return [];
    }
  }


}
