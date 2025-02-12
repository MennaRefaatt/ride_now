import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/driver/driver_registration/data/models/brand_model.dart';
import 'package:ride_now/features/driver/driver_registration/data/models/model_model.dart';
import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../models/color_model.dart';
import '../models/driver_registration_model.dart';

abstract class DriverRegistrationRemoteDataSource {
  Future<bool> registerDriver(DriverRegistrationModel model);
  Future<List<ColorModel>> fetchColors();
  Future<List<BrandModel>> fetchBrands();
  Future<List<ModelModel>> fetchModels();
}

class DriverRegistrationRemoteDataSourceImpl
    implements DriverRegistrationRemoteDataSource {
  final FirebaseFirestore firestore;

  DriverRegistrationRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<bool> registerDriver(DriverRegistrationModel model) async {
    try {
      final jsonData = model.toJson();
      final String? userId = SharedPref.getString(key: MySharedKeys.userId);
      if (userId == null) {
        safePrint("User ID not found in SharedPreferences.");
        return false;
      }
      await firestore.collection("drivers").doc(userId).set(jsonData);

      safePrint("Driver registered with data: $jsonData");
      return true;
    } catch (e) {
      safePrint("Error registering driver: $e");
      return false;
    }
  }

  @override
  Future<List<BrandModel>> fetchBrands() async {
    try {
      var querySnapshot = await firestore.collection('brands').get();
      safePrint("Fetched Brands: ${querySnapshot.docs.map((e) => e.data())}");
      return querySnapshot.docs
          .map((doc) => BrandModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      safePrint("Error fetching brands: $e");
      return [];
    }
  }

  @override
  Future<List<ModelModel>> fetchModels() async {
    try {
      var querySnapshot = await firestore.collection('models').get();
      safePrint("Fetched Models: ${querySnapshot.docs.map((e) => e.data())}");
      return querySnapshot.docs
          .map((doc) => ModelModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      safePrint("Error fetching models: $e");
      return [];
    }
  }

  @override
  Future<List<ColorModel>> fetchColors() async {
    try {
      var querySnapshot = await firestore.collection('colors').get();
      safePrint("Fetched Colors: ${querySnapshot.docs.map((e) => e.data())}");

      return querySnapshot.docs
          .map((doc) {
            try {
              return ColorModel.fromJson(doc.data());
            } catch (e) {
              safePrint("Error parsing color: $e, skipping entry.");
              return null;
            }
          })
          .whereType<ColorModel>()
          .toList();
    } catch (e) {
      safePrint("Error fetching colors: $e");
      return [];
    }
  }
}
