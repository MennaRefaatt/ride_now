import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';

class DriverLicensePage extends StatelessWidget {
  const DriverLicensePage({super.key});

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
                  PickImage(text: "S().driver License", onTap: () {}),
                  PickImage(text: "S().back Side Of License", onTap: () {}),
                  PickImage(text: "S().selfie With License", onTap: () {}),
                ],
              ),
            ),
            verticalSpacing(20.h),
            TextFormEntry(
                hintText: "S().licenseNumber",
                controller: TextEditingController()),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: "S().expiryDate",
              controller: TextEditingController(),
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
