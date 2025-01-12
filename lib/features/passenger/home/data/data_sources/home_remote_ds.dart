import 'package:cloud_firestore/cloud_firestore.dart';
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
    try {
      final userId = SharedPref.getString(key: MySharedKeys.userId)!;
      final getTrips = await FirebaseFirestore.instance
          .collection('trips')
          .where("passengerData.passengerId", isEqualTo: userId)
          .get();
      safePrint(
          "passenger id:${getTrips.docs.map((doc) => doc.data()['passengerData']['passengerId'])}");
      return getTrips.docs.map((doc) {
        final data = doc.data();
        safePrint("data: $data");
        return TripModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      safePrint("Error getting trips: $e");
      throw Exception("Error getting trips: $e");
    }
  }
}
