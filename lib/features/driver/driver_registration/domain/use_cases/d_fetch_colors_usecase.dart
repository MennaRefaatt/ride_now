import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

import '../../data/models/color_model.dart';

class FetchColorsUseCase {
  final DRepoBase repository;

  FetchColorsUseCase(this.repository);

  Future<List<ColorModel>> call() => repository.fetchColors();
}
