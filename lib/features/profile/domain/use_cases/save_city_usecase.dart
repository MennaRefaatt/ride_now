import '../repositories/city_repo_base.dart';

class SaveCityUseCase {
  final CityRepoBase repository;

  SaveCityUseCase(this.repository);

  Future<void> call(String userId, String cityName) {
    return repository.saveCity(userId, cityName);
  }
}
