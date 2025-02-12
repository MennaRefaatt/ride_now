import '../../data/models/brand_model.dart';
import '../../data/models/color_model.dart';
import '../../data/models/driver_registration_model.dart';
import '../../data/models/model_model.dart';

abstract class DRepoBase {
  Future<bool> registerDriver(DriverRegistrationModel model);
  Future<List<ColorModel>> fetchColors();
  Future<List<BrandModel>> fetchBrands();
  Future<List<ModelModel>> fetchModels();
}