import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/theming/styles.dart';
import '../manager/driver_registration_cubit.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({
    super.key,
    required this.cubit,
  });

  final DriverRegistrationCubit cubit;

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
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
                  image: widget.cubit.personalImage ?? '',
                  onTap: () async {
                    await widget.cubit.pickImage();
                    setState(() {});
                  }),
              verticalSpacing(20.h),
              TextFormEntry(
                hintText: "First Name",
                controller: firstNameController,
                onChanged: (value) => widget.cubit.updatePersonalInfo(
                    value,
                    lastNameController.text,
                    dateOfBirthController.text,
                    widget.cubit.personalImage ?? ''),
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
                onChanged: (value) => widget.cubit.updatePersonalInfo(
                  firstNameController.text,
                  value,
                  dateOfBirthController.text,
                  widget.cubit.personalImage ?? '',
                ),
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
                onChanged: (value) => widget.cubit.updatePersonalInfo(
                  firstNameController.text,
                  lastNameController.text,
                  value,
                  widget.cubit.personalImage ?? '',
                ),
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
