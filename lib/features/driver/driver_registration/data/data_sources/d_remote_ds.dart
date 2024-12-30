import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helpers/safe_print.dart';
import '../models/driver_registration_model.dart';

abstract class DriverRegistrationRemoteDataSource {
  Future<void> registerDriver(DriverRegistrationModel model);
  Future<List<Map<String, dynamic>>> fetchColors();
  Future<List<Map<String, dynamic>>> fetchBrands();
  Future<List<Map<String, dynamic>>> fetchModels();
}

class DriverRegistrationRemoteDataSourceImpl
    implements DriverRegistrationRemoteDataSource {
  @override
  Future<void> registerDriver(DriverRegistrationModel model) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("drivers")
          .add(model.toJson());
      safePrint("Driver registered with ID: ${result.id}");
    } catch (e) {
      return Future.error(e);
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
