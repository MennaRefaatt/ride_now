import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';


class PersonalDocumentsPage extends StatelessWidget {
  const PersonalDocumentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('S().personalDocuments', style: TextStyles.font24BlackBold,),
            verticalSpacing(20.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PickImage(text: "S().national ID", onTap: () {}),
                  PickImage(text: "S().backSide Of ID", onTap: () {}),
                  PickImage(text: "S().criminal status record", onTap: () {}),
                ],
              ),
            ),
            verticalSpacing(20.h),
            TextFormEntry(
              hintText: "S().iDNumber",
              maxLength: 15,
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }
}
