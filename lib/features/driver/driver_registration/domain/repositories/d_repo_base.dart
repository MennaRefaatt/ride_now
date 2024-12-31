import '../../data/models/driver_registration_model.dart';

abstract class DRepoBase {
  Future<bool> registerDriver(DriverRegistrationModel model);
  Future<List<Map<String, dynamic>>> fetchColors();
  Future<List<Map<String, dynamic>>> fetchBrands();
  Future<List<Map<String, dynamic>>> fetchModels();
}