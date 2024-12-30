import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
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
  TextEditingController _licenseNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: SingleChildScrollView(
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
                      text: "S().driver License",
                      image: widget.cubit.driverLicenseImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage();
                        setState(() {});
                      }),
                  PickImage(
                      text: "S().back Side Of License",
                      image: widget.cubit.backLicenseImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage();
                        setState(() {});
                      }),
                  PickImage(
                      text: "S().selfie With License",
                      image: widget.cubit.selfieWithLicenseImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage();
                        setState(() {});
                      }),
                ],
              ),
            ),
            verticalSpacing(20.h),
            TextFormEntry(
                onChanged: (value) => widget.cubit.updateLicenseInfo(
                    widget.cubit.driverLicenseImage ?? "",
                    widget.cubit.backLicenseImage ?? "",
                    widget.cubit.selfieWithLicenseImage ?? "",
                    value,
                    _expiryDateController.text),
                maxLength: 7,
                hintText: "S().licenceNumber",
                controller: _licenseNumberController),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: "S().expiryDate",
              onChanged: (value) => widget.cubit.updateLicenseInfo(
                widget.cubit.driverLicenseImage ?? "",
                widget.cubit.backLicenseImage ?? "",
                widget.cubit.selfieWithLicenseImage ?? "",
                _licenseNumberController.text,
                value,
              ),
              controller: _expiryDateController,
              maxLength: 10,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: DateValidator.validateDate,
            ),
          ],
        ),
      ),
    );
  }
}
