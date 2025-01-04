// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRegistrationModel _$DriverRegistrationModelFromJson(
        Map<String, dynamic> json) =>
    DriverRegistrationModel(
      driverId: json['driverId'] as String,
      driverStatus: json['driverStatus'] as String,
      personalInfo: PersonalRegistrationModel.fromJson(
          json['personalInfo'] as Map<String, dynamic>),
      vehicleInfo: VehicleRegistrationModel.fromJson(
          json['vehicleInfo'] as Map<String, dynamic>),
      driverInfo: DriverLicenseModel.fromJson(
          json['driverInfo'] as Map<String, dynamic>),
      personalDocument: PersonalDocumentModel.fromJson(
          json['personalDocument'] as Map<String, dynamic>),
      driverTripStatus: json['driverTripStatus'] as String,
      currentTripId: json['currentTripId'] as String,
    );

Map<String, dynamic> _$DriverRegistrationModelToJson(
        DriverRegistrationModel instance) =>
    <String, dynamic>{
      'driverStatus': instance.driverStatus,
      'driverTripStatus': instance.driverTripStatus,
      'driverId': instance.driverId,
      'currentTripId': instance.currentTripId,
      'personalInfo': instance.personalInfo,
      'vehicleInfo': instance.vehicleInfo,
      'driverInfo': instance.driverInfo,
      'personalDocument': instance.personalDocument,
    };

VehicleRegistrationModel _$VehicleRegistrationModelFromJson(
        Map<String, dynamic> json) =>
    VehicleRegistrationModel(
      vehicleBrand: json['vehicleBrand'] as String,
      vehicleModel: json['vehicleModel'] as String,
      vehicleColor: json['vehicleColor'] as String,
      productionYear: json['productionYear'] as String,
      plateNumber: json['plateNumber'] as String,
      vehicleImage: json['vehicleImage'] as String,
      registrationCertificate: json['registrationCertificate'] as String,
      backOfCertificate: json['backOfCertificate'] as String,
    );

Map<String, dynamic> _$VehicleRegistrationModelToJson(
        VehicleRegistrationModel instance) =>
    <String, dynamic>{
      'vehicleBrand': instance.vehicleBrand,
      'vehicleModel': instance.vehicleModel,
      'vehicleColor': instance.vehicleColor,
      'productionYear': instance.productionYear,
      'plateNumber': instance.plateNumber,
      'vehicleImage': instance.vehicleImage,
      'registrationCertificate': instance.registrationCertificate,
      'backOfCertificate': instance.backOfCertificate,
    };

PersonalRegistrationModel _$PersonalRegistrationModelFromJson(
        Map<String, dynamic> json) =>
    PersonalRegistrationModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      personalImage: json['personalImage'] as String,
    );

Map<String, dynamic> _$PersonalRegistrationModelToJson(
        PersonalRegistrationModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth,
      'personalImage': instance.personalImage,
    };

DriverLicenseModel _$DriverLicenseModelFromJson(Map<String, dynamic> json) =>
    DriverLicenseModel(
      licenseNumber: json['licenseNumber'] as String,
      licenseExpiryDate: json['licenseExpiryDate'] as String,
      driverLicenseImage: json['driverLicenseImage'] as String,
      backLicenseImage: json['backLicenseImage'] as String,
      selfieWithLicenseImage: json['selfieWithLicenseImage'] as String,
    );

Map<String, dynamic> _$DriverLicenseModelToJson(DriverLicenseModel instance) =>
    <String, dynamic>{
      'licenseNumber': instance.licenseNumber,
      'driverLicenseImage': instance.driverLicenseImage,
      'backLicenseImage': instance.backLicenseImage,
      'selfieWithLicenseImage': instance.selfieWithLicenseImage,
      'licenseExpiryDate': instance.licenseExpiryDate,
    };

PersonalDocumentModel _$PersonalDocumentModelFromJson(
        Map<String, dynamic> json) =>
    PersonalDocumentModel(
      nationalId: json['nationalId'] as String,
      nationalIdImage: json['nationalIdImage'] as String,
      backOfIdImage: json['backOfIdImage'] as String,
      criminalStatusImage: json['criminalStatusImage'] as String,
    );

Map<String, dynamic> _$PersonalDocumentModelToJson(
        PersonalDocumentModel instance) =>
    <String, dynamic>{
      'nationalId': instance.nationalId,
      'nationalIdImage': instance.nationalIdImage,
      'backOfIdImage': instance.backOfIdImage,
      'criminalStatusImage': instance.criminalStatusImage,
    };
