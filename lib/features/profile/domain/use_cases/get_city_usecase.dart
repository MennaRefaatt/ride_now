import 'package:ride_now/features/profile/data/models/city_model.dart';

import '../repositories/city_repo_base.dart';
class GetCitiesUseCase {
  final CityRepoBase repository;

  GetCitiesUseCase(this.repository);

  Future<List<CityModel>> call() {
    return repository.getCities();
  }
}

