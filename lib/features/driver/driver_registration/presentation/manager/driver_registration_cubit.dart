import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/helpers/safe_print.dart';
part 'driver_registration_state.dart';

class DriverRegistrationCubit extends Cubit<DriverRegistrationState> {
  DriverRegistrationCubit() : super(DriverRegistrationInitial());

  String? firstName, lastName, dateOfBirth, personalImage;
  String? nationalIdImage, backOfIdImage, criminalStatusImage, idNumber;
  String? licenseNumber,
      licenseExpiryDate,
      driverLicenseImage,
      backLicenseImage,
      selfieWithLicenseImage;
  String? vehicleImage,
      vehicleColor,
      registrationCertificate,
      productionYear,
      plateNumber,
      vehicleRegistrationCertificate,
      vehicleBrand,
      vehicleModel,
      backOfCertificate;

  List<String> images = [];
  void updatePersonalInfo(
      String firstName, String lastName, String dob, String personalImage) {
    this.firstName = firstName;
    this.lastName = lastName;
    dateOfBirth = dob;
    this.personalImage = personalImage;
    emit(DriverRegistrationPersonalInfoUpdated());
  }
  Future<List<Map<String, dynamic>>> fetchColors() async {
    var querySnapshot =
    await FirebaseFirestore.instance.collection('colors').get();
    return querySnapshot.docs.map((doc) {
      String hexCode = doc['hexCode'];
      try {
        return {
          'name': doc['name'],
          'color': Color(int.parse(hexCode)),
        };
      } catch (e) {
        safePrint("Error parsing color: $e, using default color");
        return {
          'name': doc['name'],
          'color': Colors.transparent,
        };
      }
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchBrands() async {
    var querySnapshot =
    await FirebaseFirestore.instance.collection('brands').get();
    return querySnapshot.docs
        .map((doc) => {'name': doc['name'], 'country': doc['country']})
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchModels() async {
    var querySnapshot =
    await FirebaseFirestore.instance.collection('models').get();
    return querySnapshot.docs.map((doc) => {'name': doc['name']}).toList();
  }

  void updateVehicleInfo(
      String brand,
      String model,
      String color,
      String productionYear,
      String plateNumber,
      String vehicleImage,
      String? vehicleRegistrationCertificate,
      String? backOfCertificate) {
    vehicleBrand = brand;
    vehicleModel = model;
    vehicleColor = color;
    this.productionYear = productionYear;
    this.plateNumber = plateNumber;
    this.vehicleImage = vehicleImage;
    this.vehicleRegistrationCertificate = vehicleRegistrationCertificate;
    this.backOfCertificate = backOfCertificate;
    emit(DriverRegistrationVehicleInfoUpdated());
  }

  void updateLicenseInfo(
      String licenseNumber,
      String expiryDate,
      String driverLicenseImage,
      String backLicenseImage,
      String selfieWithLicenseImage) {
    this.licenseNumber = licenseNumber;
    licenseExpiryDate = expiryDate;
    this.driverLicenseImage = driverLicenseImage;
    this.backLicenseImage = backLicenseImage;
    this.selfieWithLicenseImage = selfieWithLicenseImage;
    emit(DriverRegistrationLicenseInfoUpdated());
  }

  void updateDocumentsInfo(String idNumber, String nationalIdImage,
      String backOfIdImage, String criminalStatusImage) {
    this.idNumber = idNumber;
    this.nationalIdImage = nationalIdImage;
    this.backOfIdImage = backOfIdImage;
    this.criminalStatusImage = criminalStatusImage;
    emit(DriverRegistrationDocumentsUpdated());
  }

  Future<void> submitRegistration() async {
    try {
      emit(DriverRegistrationLoading());
      await FirebaseFirestore.instance.collection('drivers').add({
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'vehicleBrand': vehicleBrand,
        'vehicleModel': vehicleModel,
        'vehicleColor': vehicleColor,
        'productionYear': productionYear,
        'plateNumber': plateNumber,
        'licenseNumber': licenseNumber,
        'licenseExpiryDate': licenseExpiryDate,
        'idNumber': idNumber,
        'registrationStatus': 'pending',
        'images': images,
      });
      emit(DriverRegistrationSuccess());
    } catch (e) {
      emit(DriverRegistrationFailure(error: e.toString()));
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      emit(DriverRegistrationLoading());
      images.add(image.path);
      emit(DriverRegistrationDocumentsUpdated());
    } else {
      emit(DriverRegistrationFailure(error: 'No image selected'));
    }
  }
}
