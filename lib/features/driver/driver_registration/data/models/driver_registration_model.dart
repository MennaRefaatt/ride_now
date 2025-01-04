import 'package:freezed_annotation/freezed_annotation.dart';
part 'driver_registration_model.g.dart';
@JsonSerializable()
class DriverRegistrationModel{
  final String driverStatus;
  final String driverTripStatus;
  final String driverId;
  final String currentTripId;
  final PersonalRegistrationModel personalInfo;
  final VehicleRegistrationModel vehicleInfo;
  final DriverLicenseModel driverInfo;
  final PersonalDocumentModel personalDocument;

  DriverRegistrationModel({
    required this.driverId,
    required this.driverStatus,
    required this.personalInfo,
    required this.vehicleInfo,
    required this.driverInfo,
    required this.personalDocument,
    required this.driverTripStatus,
    required this.currentTripId
  });

  factory DriverRegistrationModel.fromJson(Map<String, dynamic> json) => _$DriverRegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => {
    'driverStatus': driverStatus,
    'driverId': driverId,
    'currentTripId': currentTripId,
    'driverTripStatus': driverTripStatus,
    'personalInfo': personalInfo.toJson(),
    'vehicleInfo': vehicleInfo.toJson(),
    'driverInfo': driverInfo.toJson(),
    'personalDocument': personalDocument.toJson(),
  };
}
@JsonSerializable()
class VehicleRegistrationModel{
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleColor;
  final String productionYear;
  final String plateNumber;
  final String vehicleImage;
  final String registrationCertificate;
  final String backOfCertificate;
  VehicleRegistrationModel({
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.productionYear,
    required this.plateNumber,
    required this.vehicleImage,
    required this.registrationCertificate,
    required this.backOfCertificate,
  });

  factory VehicleRegistrationModel.fromJson(Map<String, dynamic> json) => _$VehicleRegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleRegistrationModelToJson(this);
}

@JsonSerializable()
class PersonalRegistrationModel{
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String personalImage;
  PersonalRegistrationModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.personalImage,
  });

  factory PersonalRegistrationModel.fromJson(Map<String, dynamic> json) => _$PersonalRegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalRegistrationModelToJson(this);
}
@JsonSerializable()
class DriverLicenseModel{
  final String licenseNumber;
  final String driverLicenseImage;
  final String backLicenseImage;
  final String selfieWithLicenseImage;
  final String licenseExpiryDate;
  DriverLicenseModel({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.driverLicenseImage,
    required this.backLicenseImage,
    required this.selfieWithLicenseImage,
  });

  factory DriverLicenseModel.fromJson(Map<String, dynamic> json) => _$DriverLicenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverLicenseModelToJson(this);
}

@JsonSerializable()
class PersonalDocumentModel{
  final String nationalId;
  final String nationalIdImage;
  final String backOfIdImage;
  final String criminalStatusImage;
  PersonalDocumentModel({
    required this.nationalId,
    required this.nationalIdImage,
    required this.backOfIdImage,
    required this.criminalStatusImage,
  });

  factory PersonalDocumentModel.fromJson(Map<String, dynamic> json) => _$PersonalDocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalDocumentModelToJson(this);
}