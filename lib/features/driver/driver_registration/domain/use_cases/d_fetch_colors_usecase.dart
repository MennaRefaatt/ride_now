import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

class FetchColorsUseCase {
  final DRepoBase repository;

  FetchColorsUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() => repository.fetchColors();
}
