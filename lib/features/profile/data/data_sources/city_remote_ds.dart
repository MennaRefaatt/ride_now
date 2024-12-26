import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/city_model.dart';

abstract class CityRemoteDS {
  Future<List<CityModel>> getCities(String query);
  Future<void> saveCity(String userId, String cityName);
}

class CityRemoteDSImpl implements CityRemoteDS {
  final FirebaseFirestore firestore;

  CityRemoteDSImpl(this.firestore);

  @override
  Future<List<CityModel>> getCities(String query) async {
    try {
      final querySnapshot = await firestore
          .collection('city')
          .where('cityName', isGreaterThanOrEqualTo: query)
          .get();
      return querySnapshot.docs
          .map((doc) => CityModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error getting cities: $e");
    }
  }

  @override
  Future<void> saveCity(String userId, String cityName) async {
    try {
      await firestore.collection('users').doc(userId).update({'city': cityName});
    } catch (e) {
      throw Exception("Error saving city: $e");
    }
  }
}
