import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

class FetchModelsUseCase {
  final DRepoBase repository;

  FetchModelsUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() => repository.fetchModels();
}
