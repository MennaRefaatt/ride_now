import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/image_type_enum.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';

class DriverLicensePage extends StatefulWidget {
  const DriverLicensePage({super.key, required this.cubit});
  final DriverRegistrationCubit cubit;

  @override
  State<DriverLicensePage> createState() => _DriverLicensePageState();
}

class _DriverLicensePageState extends State<DriverLicensePage> {
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  @override
  void initState() {
    _licenseNumberController.text = widget.cubit.licenseNumber ?? '';
    _expiryDateController.text = widget.cubit.licenseExpiryDate ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: SingleChildScrollView(
        child: Form(
          key: widget.cubit.licenseFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver License',
                style: TextStyles.font24BlackBold,
              ),
              verticalSpacing(20.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PickImage(
                      text: "Driver License",
                      image: widget.cubit.driverLicenseImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage(ImageType.driverLicense);
                        setState(() {});
                      },
                    ),
                    PickImage(
                      text: "Back Side Of License",
                      image: widget.cubit.backLicenseImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage(ImageType.backLicense);
                        setState(() {});
                      },
                    ),
                    PickImage(
                      text: "Selfie With License",
                      image: widget.cubit.selfieWithLicenseImage ?? '',
                      onTap: () async {
                        await widget.cubit
                            .pickImage(ImageType.selfieWithLicense);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              verticalSpacing(20.h),
              TextFormEntry(
                onChanged: (value) => widget.cubit.updateLicenseInfo(
                  licenseNumber: value,
                  expiryDate: _expiryDateController.text,
                  driverLicenseImage: widget.cubit.driverLicenseImage ?? "",
                  backLicenseImage: widget.cubit.backLicenseImage ?? "",
                  selfieWithLicenseImage:
                      widget.cubit.selfieWithLicenseImage ?? "",
                ),
                maxLength: 7,
                hintText: "License Number",
                controller: _licenseNumberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your license number';
                  }
                  return null;
                },
              ),
              verticalSpacing(10.h),
              TextFormEntry(
                hintText: "Expiry Date",
                onChanged: (value) => widget.cubit.updateLicenseInfo(
                  licenseNumber: _licenseNumberController.text,
                  expiryDate: value,
                  driverLicenseImage: widget.cubit.driverLicenseImage ?? "",
                  backLicenseImage: widget.cubit.backLicenseImage ?? "",
                  selfieWithLicenseImage:
                      widget.cubit.selfieWithLicenseImage ?? "",
                ),
                controller: _expiryDateController,
                maxLength: 10,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.datetime,
                validator: ExpiryDateValidator.validateExpiryDate,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ExpiryDateInputFormatter(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
