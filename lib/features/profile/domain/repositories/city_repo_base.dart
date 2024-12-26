
import 'package:ride_now/features/profile/data/models/city_model.dart';
abstract class CityRepoBase {
  Future<List<CityModel>> getCities();
  Future<void> saveCity(String userId, String cityName);
}
