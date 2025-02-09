import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    required Future<void> itemsFuture,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => DriverBottomSheet(
        type: type,
        controller: controller,
        itemsFuture: itemsFuture,
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
            verticalSpacing(20.h),
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
                        setState(() {});
                      }),
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
            InkWell(
              onTap: () => _showBottomSheet(
                context: context,
                type: "brand",
                controller: _brandController,
                itemsFuture: widget.cubit.fetchBrands(),
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
            verticalSpacing(10.h),
            InkWell(
              onTap: () => _showBottomSheet(
                context: context,
                type: "model",
                controller: _modelController,
                itemsFuture: widget.cubit.fetchModels(),
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
            verticalSpacing(10.h),
            InkWell(
                onTap: () => _showBottomSheet(
                      context: context,
                      type: "color",
                      controller: _colorController,
                      itemsFuture: widget.cubit.fetchColors(),
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
            verticalSpacing(10.h),
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
            verticalSpacing(10.h),
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
                validator: VehiclePlateValidator.validatePlateNumber),
          ],
        ),
      ),
    );
  }
}
