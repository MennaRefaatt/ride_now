import '../../domain/repositories/city_repo_base.dart';
import '../data_sources/city_remote_ds.dart';
import '../models/city_model.dart';

class CityRepoImpl implements CityRepoBase {
  final CityRemoteDS remoteDS;

  CityRepoImpl(this.remoteDS);

  @override
  Future<List<CityModel>> getCities({String query = ''}) {
    return remoteDS.getCities(query);
  }

  @override
  Future<void> saveCity(String userId, String cityName) {
    return remoteDS.saveCity(userId, cityName);
  }
}
