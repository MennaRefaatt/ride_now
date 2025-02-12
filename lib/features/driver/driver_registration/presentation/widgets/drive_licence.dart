import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/image_type_enum.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S().driverLicence,
              style: TextStyles.font24BlackBold,
            ),
            verticalSpacing(20.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PickImage(
                    text: S().driverLicence,
                    image: widget.cubit.driverLicenseImage ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.driverLicense);
                      setState(() {});
                    },
                  ),
                  PickImage(
                    text: S().backSideOfLicence,
                    image: widget.cubit.backLicenseImage ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.backLicense);
                      setState(() {});
                    },
                  ),
                  PickImage(
                    text: S().selfieWithLicence,
                    image: widget.cubit.selfieWithLicenseImage ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.selfieWithLicense);
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
              maxLength: 14,
              hintText: S().licenceNumber,
              controller: _licenseNumberController,
              textInputAction: TextInputAction.next,
              validator:LicenseNumberValidator.validateLicenseNumber,
            ),
            verticalSpacing(10),
            TextFormEntry(
              hintText: S().expiryDate,
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
    );
  }
}
