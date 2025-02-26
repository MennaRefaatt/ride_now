import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/driver_bottom_sheet.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/driver_registration_cubit.dart';
import 'image_type_enum.dart';

class VehicleInformationPage extends StatefulWidget {
  const VehicleInformationPage({super.key, required this.cubit});
  final DriverRegistrationCubit cubit;
  @override
  State<VehicleInformationPage> createState() => _VehicleInformationPageState();
}

class _VehicleInformationPageState extends State<VehicleInformationPage> {
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _productionYearController =
      TextEditingController();
  @override
  void initState() {
    _colorController.text = widget.cubit.vehicleColor ?? '';
    _modelController.text = widget.cubit.vehicleModel ?? '';
    _brandController.text = widget.cubit.vehicleBrand ?? '';
    _plateNumberController.text = widget.cubit.plateNumber ?? '';
    _productionYearController.text = widget.cubit.productionYear ?? '';
    super.initState();
  }

  void _showBottomSheet({
    required BuildContext context,
    required String type,
    required TextEditingController controller,
  }) {
    final cubit = context.read<DriverRegistrationCubit>();

    if (type == "brand") cubit.fetchBrands();
    if (type == "model") cubit.fetchModels();
    if (type == "color") cubit.fetchColors();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: DriverBottomSheet(type: type, controller: controller),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S().vehicleInformation, style: TextStyles.font24BlackBold),
            verticalSpacing(20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PickImage(
                    text: S().vehiclePicture,
                    image: widget.cubit.vehicleImage ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.vehicleImage);
                      if (widget.cubit.vehicleImage != null && widget.cubit.vehicleImage!.isNotEmpty) {
                        String extractedPlate = await scanPlateNumber(widget.cubit.vehicleImage!);
                        setState(() {
                          _plateNumberController.text = extractedPlate;
                          widget.cubit.updateVehicleInfo(
                            plateNumber: extractedPlate,
                            brand: _brandController.text,
                            model: _modelController.text,
                            color: _colorController.text,
                            productionYear: _productionYearController.text,
                            vehicleImage: widget.cubit.vehicleImage ?? '',
                            vehicleRegistrationCertificate: widget.cubit.registrationCertificate ?? '',
                            backOfCertificate: widget.cubit.backOfCertificate ?? '',
                          );
                        });
                      }
                    },
                  ),
                  PickImage(
                    text: S().vehicleRegistrationCertificate,
                    image: widget.cubit.registrationCertificate ?? '',
                    onTap: () async {
                      await widget.cubit
                          .pickImage(ImageType.vehicleRegistrationCertificate);
                      setState(() {});
                    },
                  ),
                  PickImage(
                    text: S().backSideOfCertificate,
                    image: widget.cubit.backOfCertificate ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.backOfCertificate);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            // BlocBuilder<DriverRegistrationCubit, DriverRegistrationState>(
            //   builder: (context, state) {
            //     if (state is DriverRegistrationDataFetched) {
            //       return DropdownButton<String>(
            //         value: _brandController.text.isNotEmpty ? _brandController.text : null,
            //         items: state.brands
            //             .map((brand) => DropdownMenuItem<String>(
            //           value: brand.name,
            //           child: Text(brand.name),
            //         ))
            //             .toList(),
            //         onChanged: (value) {
            //           setState(() {
            //             _brandController.text = value!;
            //           });
            //         },
            //       );
            //     }
            //     return CircularProgressIndicator();
            //   },
            // ),
            InkWell(
              onTap: () => _showBottomSheet(
                context: context,
                type: "brand",
                controller: _brandController,
              ),
              child: TextFormEntry(
                hintText: S().vehicleBrand,
                controller: _brandController,
                enable: false,
                onChanged: (value) => widget.cubit.updateVehicleInfo(
                  brand: value,
                  model: _modelController.text,
                  color: _colorController.text,
                  productionYear: _productionYearController.text,
                  plateNumber: _plateNumberController.text,
                  vehicleImage: widget.cubit.vehicleImage ?? '',
                  vehicleRegistrationCertificate:
                      widget.cubit.registrationCertificate ?? '',
                  backOfCertificate: widget.cubit.backOfCertificate ?? '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S().requiredField;
                  }
                  return null;
                },
              ),
            ),
            verticalSpacing(10),
            InkWell(
              onTap: () => _showBottomSheet(
                context: context,
                type: "model",
                controller: _modelController,
              ),
              child: TextFormEntry(
                hintText: S().vehicleModel,
                controller: _modelController,
                enable: false,
                onChanged: (value) => widget.cubit.updateVehicleInfo(
                  brand: _brandController.text,
                  model: value,
                  color: _colorController.text,
                  productionYear: _productionYearController.text,
                  plateNumber: _plateNumberController.text,
                  vehicleImage: widget.cubit.vehicleImage ?? '',
                  vehicleRegistrationCertificate:
                      widget.cubit.registrationCertificate ?? '',
                  backOfCertificate: widget.cubit.backOfCertificate ?? '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S().requiredField;
                  }
                  return null;
                },
              ),
            ),
            verticalSpacing(10),
            InkWell(
                onTap: () => _showBottomSheet(
                      context: context,
                      type: "color",
                      controller: _colorController,
                    ),
                child: TextFormEntry(
                  hintText: S().vehicleColor,
                  enable: false,
                  controller: _colorController,
                  onChanged: (value) => widget.cubit.updateVehicleInfo(
                    brand: _brandController.text,
                    model: _modelController.text,
                    color: value,
                    productionYear: _productionYearController.text,
                    plateNumber: _plateNumberController.text,
                    vehicleImage: widget.cubit.vehicleImage ?? '',
                    vehicleRegistrationCertificate:
                        widget.cubit.registrationCertificate ?? '',
                    backOfCertificate: widget.cubit.backOfCertificate ?? '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S().requiredField;
                    }
                    return null;
                  },
                )),
            verticalSpacing(10),
            TextFormEntry(
              hintText: S().productionYear,
              controller: _productionYearController,
              onChanged: (value) => widget.cubit.updateVehicleInfo(
                brand: _brandController.text,
                model: _modelController.text,
                color: _colorController.text,
                productionYear: value,
                plateNumber: _plateNumberController.text,
                vehicleImage: widget.cubit.vehicleImage ?? '',
                vehicleRegistrationCertificate:
                    widget.cubit.registrationCertificate ?? '',
                backOfCertificate: widget.cubit.backOfCertificate ?? '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                YearInputFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid year';
                }
                final year = int.tryParse(value);
                if (year == null || year < 1900 || year > DateTime.now().year) {
                  return 'Enter a year between 1900 and ${DateTime.now().year}';
                }
                return null;
              },
              maxLength: 4,
              keyboardType: TextInputType.number,
            ),
            verticalSpacing(10),
            TextFormEntry(
                hintText: S().vehiclePlateNumber,
                controller: _plateNumberController,
                onChanged: (value) => widget.cubit.updateVehicleInfo(
                      brand: _brandController.text,
                      model: _modelController.text,
                      color: _colorController.text,
                      productionYear: _productionYearController.text,
                      plateNumber: value,
                      vehicleImage: widget.cubit.vehicleImage ?? '',
                      vehicleRegistrationCertificate:
                          widget.cubit.registrationCertificate ?? '',
                      backOfCertificate: widget.cubit.backOfCertificate ?? '',
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S().requiredField;
                  }
                  return null;
                }),],
        ),
      ),
    );
  }
  Future<String> scanPlateNumber(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String plateNumber = extractPlateNumber(recognizedText);
      return plateNumber.isNotEmpty ? plateNumber : "لم يتم التعرف على رقم اللوحة";
    } catch (e) {
      return "حدث خطأ أثناء المسح: $e";
    } finally {
      textRecognizer.close();
    }
  }
  String extractPlateNumber(RecognizedText recognizedText) {
    List<String> plateParts = [];

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String text = line.text.trim(); // إزالة الفراغات الزائدة
        plateParts.add(text);
      }
    }

    // تجميع النص كما هو بدون أي تعديلات
    String plateNumber = plateParts.join(' ');

    return plateNumber.isNotEmpty ? plateNumber : "لم يتم التعرف على رقم اللوحة";
  }
  String convertNumbersToArabic(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(RegExp(r'[0-9]'), (match) {
      return arabicNumbers[int.parse(match.group(0)!)];
    });
  }

}
