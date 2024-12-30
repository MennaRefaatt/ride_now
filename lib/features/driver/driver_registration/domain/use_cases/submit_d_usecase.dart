import 'package:ride_now/features/driver/driver_registration/data/models/driver_registration_model.dart';
import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';

class SubmitDriverRegistrationUseCase {
  final DRepoBase repository;

  SubmitDriverRegistrationUseCase(this.repository);

  Future<void> call(DriverRegistrationModel driverData) =>
      repository.registerDriver(driverData);
}