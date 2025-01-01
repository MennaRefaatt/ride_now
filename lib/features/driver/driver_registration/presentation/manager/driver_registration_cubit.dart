import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_now/core/helpers/enums/driver_trip_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/driver/driver_registration/data/models/driver_registration_model.dart';
import '../../../../../core/helpers/enums/driver_status.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../domain/use_cases/d_fetch_colors_usecase.dart';
import '../../domain/use_cases/fetch_brands_usecase.dart';
import '../../domain/use_cases/fetch_models_usecase.dart';
import '../../domain/use_cases/submit_d_usecase.dart';
import '../widgets/image_type_enum.dart';
part 'driver_registration_state.dart';

class DriverRegistrationCubit extends Cubit<DriverRegistrationState> {
  DriverRegistrationCubit({
    required this.fetchColorsUseCase,
    required this.fetchModelsUseCase,
    required this.fetchBrandsUseCase,
    required this.submitDriverRegistrationUseCase,
  }) : super(DriverRegistrationInitial());

  final FetchColorsUseCase fetchColorsUseCase;
  final FetchModelsUseCase fetchModelsUseCase;
  final FetchBrandsUseCase fetchBrandsUseCase;
  final SubmitDriverRegistrationUseCase submitDriverRegistrationUseCase;
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

  Future<void> fetchColors() async {
    emit(DriverRegistrationLoading());
    try {
      final colors = await fetchColorsUseCase();
      emit(DriverRegistrationColorsFetched(colors));
    } catch (e) {
      emit(DriverRegistrationFailure(error: e.toString()));
    }
  }

  Future<void> fetchBrands() async {
    emit(DriverRegistrationLoading());
    try {
      final brands = await fetchBrandsUseCase();
      emit(DriverRegistrationBrandsFetched(brands));
    } catch (e) {
      emit(DriverRegistrationFailure(error: e.toString()));
    }
  }

  Future<void> fetchModels() async {
    emit(DriverRegistrationLoading());
    try {
      final models = await fetchModelsUseCase();
      emit(DriverRegistrationModelsFetched(models));
    } catch (e) {
      emit(DriverRegistrationFailure(error: e.toString()));
    }
  }

  Future<void> fetchItemsForType(String type) async {
    emit(DriverRegistrationLoading());
    try {
      if (type == 'color') {
        await fetchColors();
      } else if (type == 'brand') {
        await fetchBrands();
      } else if (type == 'model') {
        await fetchModels();
      } else {
        throw Exception('Invalid type');
      }
    } catch (e) {
      emit(DriverRegistrationFailure(error: e.toString()));
    }
  }

  void updatePersonalInfo({
    required String firstName,
    required String lastName,
    required String dob,
    required String personalImage,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    dateOfBirth = dob;
    this.personalImage = personalImage;
    emit(DriverRegistrationPersonalInfoUpdated());
  }

  void updateVehicleInfo({
    required String brand,
    required String model,
    required String color,
    required String productionYear,
    required String plateNumber,
    required String vehicleImage,
    String? vehicleRegistrationCertificate,
    String? backOfCertificate,
  }) {
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

  void updateLicenseInfo({
    required String licenseNumber,
    required String expiryDate,
    required String driverLicenseImage,
    required String backLicenseImage,
    required String selfieWithLicenseImage,
  }) {
    this.licenseNumber = licenseNumber;
    licenseExpiryDate = expiryDate;
    this.driverLicenseImage = driverLicenseImage;
    this.backLicenseImage = backLicenseImage;
    this.selfieWithLicenseImage = selfieWithLicenseImage;
    emit(DriverRegistrationLicenseInfoUpdated());
  }

  void updateDocumentsInfo({
    required String idNumber,
    required String nationalIdImage,
    required String backOfIdImage,
    required String criminalStatusImage,
  }) {
    this.idNumber = idNumber;
    this.nationalIdImage = nationalIdImage;
    this.backOfIdImage = backOfIdImage;
    this.criminalStatusImage = criminalStatusImage;
    emit(DriverRegistrationDocumentsUpdated());
  }

  Future<bool> submitRegistration() async {
    try {
      final driverData = DriverRegistrationModel(
        driverTripStatus: DriverTripStatus.available.name,
        driverStatus: DriverStatus.pending.name,
        driverId: SharedPref.getString(key: MySharedKeys.userId) ?? '',
        personalInfo: PersonalRegistrationModel(
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          dateOfBirth: dateOfBirth ?? '',
          personalImage: personalImage ?? '',
        ),
        vehicleInfo: VehicleRegistrationModel(
          vehicleBrand: vehicleBrand ?? '',
          vehicleModel: vehicleModel ?? '',
          vehicleColor: vehicleColor ?? '',
          productionYear: productionYear ?? '',
          plateNumber: plateNumber ?? '',
          vehicleImage: vehicleImage ?? '',
          registrationCertificate: registrationCertificate ?? '',
          backOfCertificate: backOfCertificate ?? '',
        ),
        driverInfo: DriverLicenseModel(
          licenseNumber: licenseNumber ?? '',
          driverLicenseImage: driverLicenseImage ?? '',
          backLicenseImage: backLicenseImage ?? '',
          selfieWithLicenseImage: selfieWithLicenseImage ?? '',
          licenseExpiryDate: licenseExpiryDate ?? '',
        ),
        personalDocument: PersonalDocumentModel(
          nationalId: idNumber ?? '',
          nationalIdImage: nationalIdImage ?? '',
          backOfIdImage: backOfIdImage ?? '',
          criminalStatusImage: criminalStatusImage ?? '',
        ),
      );

      emit(DriverRegistrationLoading());

      final isSuccess = await submitDriverRegistrationUseCase(driverData);

      if (isSuccess) {
        emit(DriverRegistrationSuccess());
        safePrint("Driver Registration Successful");
        return true; // تأكيد الإرجاع
      } else {
        emit(DriverRegistrationFailure(error: "Registration failed"));
        return false; // تأكيد الإرجاع
      }
    } catch (e) {
      emit(DriverRegistrationFailure(error: e.toString()));
      return false; // إرجاع قيمة في حالة حدوث خطأ
    }
  }

  Future<void> pickImage(ImageType type) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      emit(DriverRegistrationLoading());

      switch (type) {
        case ImageType.driverLicense:
          driverLicenseImage = image.path;
          break;
        case ImageType.backLicense:
          backLicenseImage = image.path;
          break;
        case ImageType.selfieWithLicense:
          selfieWithLicenseImage = image.path;
          break;
        case ImageType.nationalIdImage:
          nationalIdImage = image.path;
          break;
        case ImageType.backOfIdImage:
          backOfIdImage = image.path;
          break;
        case ImageType.criminalStatusImage:
          criminalStatusImage = image.path;
          break;
        case ImageType.personalImage:
          personalImage = image.path;
          break;
        case ImageType.vehicleImage:
          vehicleImage = image.path;
          break;
        case ImageType.vehicleRegistrationCertificate:
          registrationCertificate = image.path;
          break;
        case ImageType.backOfCertificate:
          backOfCertificate = image.path;
          break;
        default:
          break;
      }

      emit(DriverRegistrationDocumentsUpdated());
    } else {
      emit(DriverRegistrationFailure(error: 'No image selected'));
    }
  }
}
