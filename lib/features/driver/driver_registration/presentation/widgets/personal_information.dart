import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/theming/styles.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController dateOfBirthController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Personal Information', style: TextStyles.font24BlackBold),
              verticalSpacing(20.h),
              PickImage(
                text: "Pick your personal picture",
                onTap: () {
                },
              ),
              verticalSpacing(20.h),
              TextFormEntry(
                hintText: "First Name",
                controller: firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              verticalSpacing(10.h),
              TextFormEntry(
                hintText: "Last Name",
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              verticalSpacing(10.h),
              TextFormEntry(
                hintText: "Date of Birth",
                controller: dateOfBirthController,
                keyboardType: TextInputType.datetime,
                maxLength: 10,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RealDateInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your birthdate';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
