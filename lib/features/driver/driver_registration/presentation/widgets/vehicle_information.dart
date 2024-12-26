import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';

class VehicleInformationPage extends StatelessWidget {
  const VehicleInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('S().vehicleInformation', style: TextStyles.font24BlackBold),
            verticalSpacing(20.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PickImage(text: "S().vehicle Picture", onTap: () {}),
                  PickImage(
                      text: "S().vehicle Registration Certificate", onTap: () {}),
                  PickImage(text: "S().backSide Of Certificate", onTap: () {}),
                ],
              ),
            ),
            TextFormEntry(
              hintText: "S().vehicleBrand",
              controller: TextEditingController(),
            ),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: "S().vehicleModel",
              controller: TextEditingController(),
            ),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: "S().vehicleColor",
              controller: TextEditingController(),
            ),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: "S().productionYear",
              controller: TextEditingController(),
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
              hintText: "S().plateNumber",
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }
}
