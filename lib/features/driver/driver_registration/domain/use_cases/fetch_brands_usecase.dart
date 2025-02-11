import 'package:ride_now/features/driver/driver_registration/data/models/brand_model.dart';
import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

class FetchBrandsUseCase {
  final DRepoBase repository;

  FetchBrandsUseCase(this.repository);

  Future<List<BrandModel>> call() => repository.fetchBrands();
}
