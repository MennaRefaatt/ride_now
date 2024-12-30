import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

class FetchBrandsUseCase {
  final DRepoBase repository;

  FetchBrandsUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() => repository.fetchBrands();
}
