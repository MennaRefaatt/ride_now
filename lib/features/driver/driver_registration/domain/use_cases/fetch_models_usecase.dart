import 'package:ride_now/features/driver/driver_registration/data/models/model_model.dart';
import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

class FetchModelsUseCase {
  final DRepoBase repository;

  FetchModelsUseCase(this.repository);

  Future<List<ModelModel>> call() => repository.fetchModels();
}
