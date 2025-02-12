part of 'driver_registration_cubit.dart';

@immutable
sealed class DriverRegistrationState {}

final class DriverRegistrationInitial extends DriverRegistrationState {}

class DriverRegistrationPersonalInfoUpdated extends DriverRegistrationState {}

class DriverRegistrationVehicleInfoUpdated extends DriverRegistrationState {}

class DriverRegistrationLicenseInfoUpdated extends DriverRegistrationState {}

class DriverRegistrationDocumentsUpdated extends DriverRegistrationState {}

class DriverRegistrationLoading extends DriverRegistrationState {}

class DriverRegistrationDataFetched extends DriverRegistrationState {
  final List<ColorModel> colors;
  final List<BrandModel> brands;
  final List<ModelModel> models;

  DriverRegistrationDataFetched(this.colors, this.brands, this.models);
}

class DriverRegistrationSuccess extends DriverRegistrationState {}

class DriverRegistrationFailure extends DriverRegistrationState {
  final String error;
  DriverRegistrationFailure({required this.error});
}

class DriverRegistrationColorsLoading extends DriverRegistrationState {}
class DriverRegistrationColorsFetched extends DriverRegistrationState {
  final List<ColorModel> colors;
  DriverRegistrationColorsFetched(this.colors);
}
class DriverRegistrationBrandsLoading extends DriverRegistrationState {}

class DriverRegistrationBrandsFetched extends DriverRegistrationState {
  final List<BrandModel> brands;
  DriverRegistrationBrandsFetched(this.brands);
}
class DriverRegistrationModelsLoading extends DriverRegistrationState {}

class DriverRegistrationModelsFetched extends DriverRegistrationState {
  final List<ModelModel> models;
  DriverRegistrationModelsFetched(this.models);
}

class DriverRegistrationColorsFailure extends DriverRegistrationState {
  final String error;
  DriverRegistrationColorsFailure({required this.error});
}
class DriverRegistrationBrandsFailure extends DriverRegistrationState {
  final String error;
  DriverRegistrationBrandsFailure({required this.error});
}
class DriverRegistrationModelsFailure extends DriverRegistrationState {
  final String error;
  DriverRegistrationModelsFailure({required this.error});
}
