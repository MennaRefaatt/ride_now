import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../models/driver_registration_model.dart';

abstract class DriverRegistrationRemoteDataSource {
  Future<bool> registerDriver(DriverRegistrationModel model);
  Future<List<Map<String, dynamic>>> fetchColors();
  Future<List<Map<String, dynamic>>> fetchBrands();
  Future<List<Map<String, dynamic>>> fetchModels();
}

class DriverRegistrationRemoteDataSourceImpl
    implements DriverRegistrationRemoteDataSource {
  @override
  Future<bool> registerDriver(DriverRegistrationModel model) async {
    try {
      final jsonData = model.toJson();
      final String? userId = SharedPref.getString(key: MySharedKeys.userId);
      if (userId == null) {
        safePrint("User ID not found in SharedPreferences.");
        return false;
      }
      await FirebaseFirestore.instance
          .collection("drivers")
          .doc(userId)
          .set(jsonData);

      safePrint("Driver registered with data: $jsonData");
      return true;
    } catch (e) {
      safePrint("Error registering driver: $e");
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('brands').get();
    safePrint("Fetched Brands: ${querySnapshot.docs.map((e) => e.data())}");
    return querySnapshot.docs
        .map((doc) => {
              'name': doc['name'],
              'country': doc['country'],
            })
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchModels() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('models').get();
    safePrint("Fetched Models: ${querySnapshot.docs.map((e) => e.data())}");
    return querySnapshot.docs.map((doc) => {'name': doc['name']}).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchColors() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('colors').get();
    safePrint("Fetched Colors: ${querySnapshot.docs.map((e) => e.data())}");
    return querySnapshot.docs.map((doc) {
      String hexCode = doc['hexCode'];
      try {
        return {
          'name': doc['name'],
          'color': Color(int.parse(hexCode)),
        };
      } catch (e) {
        safePrint("Error parsing color: $e, using default color");
        return {
          'name': doc['name'],
          'color': Colors.transparent,
        };
      }
    }).toList();
  }
}
