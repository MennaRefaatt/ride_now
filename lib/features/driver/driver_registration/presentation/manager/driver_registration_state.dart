part of 'driver_registration_cubit.dart';

@immutable
sealed class DriverRegistrationState {}

final class DriverRegistrationInitial extends DriverRegistrationState {}

class DriverRegistrationPersonalInfoUpdated extends DriverRegistrationState {}

class DriverRegistrationVehicleInfoUpdated extends DriverRegistrationState {}

class DriverRegistrationLicenseInfoUpdated extends DriverRegistrationState {}

class DriverRegistrationDocumentsUpdated extends DriverRegistrationState {}

class DriverRegistrationLoading extends DriverRegistrationState {}

class DriverRegistrationSuccess extends DriverRegistrationState {}

class DriverRegistrationFailure extends DriverRegistrationState {
  final String error;
  DriverRegistrationFailure({required this.error});
}

class DriverRegistrationColorsFetched extends DriverRegistrationState {
  final List<Map<String, dynamic>> colors;
  DriverRegistrationColorsFetched(this.colors);
}

class DriverRegistrationBrandsFetched extends DriverRegistrationState {
  final List<Map<String, dynamic>> brands;
  DriverRegistrationBrandsFetched(this.brands);
}

class DriverRegistrationModelsFetched extends DriverRegistrationState {
  final List<Map<String, dynamic>> models;
  DriverRegistrationModelsFetched(this.models);
}
