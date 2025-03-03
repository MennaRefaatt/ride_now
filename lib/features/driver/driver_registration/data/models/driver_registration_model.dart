import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../rating/data/models/rating_model.dart';
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
  final DriverLocation location;
  final String driverToken;
  final List<String> declinedTrips;
  final RatingModel? rating;

  DriverRegistrationModel({
    required this.driverId,
    required this.driverStatus,
    required this.personalInfo,
    required this.vehicleInfo,
    required this.driverInfo,
    required this.personalDocument,
    required this.driverTripStatus,
    required this.currentTripId,
    required this.location,
    required this.driverToken,
    required this.declinedTrips,
    this.rating
  });

  factory DriverRegistrationModel.fromJson(Map<String, dynamic> json) {
    return DriverRegistrationModel(
      driverId: json['driverId'] ?? '',
      driverStatus: json['driverStatus'] ?? '',
      personalInfo: PersonalRegistrationModel.fromJson(json['personalInfo'] ?? {}),
      vehicleInfo: VehicleRegistrationModel.fromJson(json['vehicleInfo'] ?? {}),
      driverInfo: DriverLicenseModel.fromJson(json['driverInfo'] ?? {}),
      personalDocument: PersonalDocumentModel.fromJson(json['personalDocument'] ?? {}),
      driverTripStatus: json['driverTripStatus'] ?? '',
      currentTripId: json['currentTripId'] ?? '',
      location: json['location'] != null
          ? DriverLocation.fromJson(json['location'])
          : DriverLocation(latitude: 0.0, longitude: 0.0), // Default safe values
      driverToken: json['driverToken'] ?? '',
      declinedTrips: (json['declinedTrips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'driverStatus': driverStatus,
    'driverId': driverId,
    'currentTripId': currentTripId,
    'driverTripStatus': driverTripStatus,
    'location': location.toJson(),
    'personalInfo': personalInfo.toJson(),
    'vehicleInfo': vehicleInfo.toJson(),
    'driverInfo': driverInfo.toJson(),
    'personalDocument': personalDocument.toJson(),
    'driverToken': driverToken,
    'declinedTrips': declinedTrips,
    'rating': rating
  };
}
@JsonSerializable()
class DriverLocation{
  final double latitude;
  final double longitude;
  DriverLocation({
    required this.latitude,
    required this.longitude,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
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
  final String phone;
  PersonalRegistrationModel({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.personalImage,
    required this.phone,
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