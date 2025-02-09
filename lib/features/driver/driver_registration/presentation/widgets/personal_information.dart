import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/driver_registration_cubit.dart';
import 'image_type_enum.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key, required this.cubit});

  final DriverRegistrationCubit cubit;

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.cubit.firstName ?? '';
    lastNameController.text = widget.cubit.lastName ?? '';
    dateOfBirthController.text = widget.cubit.dateOfBirth ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S().personalInformation, style: TextStyles.font24BlackBold),
            verticalSpacing(20.h),
            PickImage(
              text: S().pickYourPersonalPicture,
              image: widget.cubit.personalImage ?? '',
              onTap: () async {
                await widget.cubit.pickImage(ImageType.personalImage);
                setState(() {});
              },
            ),
            verticalSpacing(20.h),
            TextFormEntry(
              hintText: S().firstName,
              controller: firstNameController,
              textInputAction: TextInputAction.next,
              onChanged: (value) => widget.cubit.updatePersonalInfo(
                firstName: value,
                lastName: lastNameController.text,
                dob: dateOfBirthController.text,
                personalImage: widget.cubit.personalImage ?? '',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S().pleaseEnterYourFirstName;
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
            ),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: S().lastName,
              textInputAction: TextInputAction.next,
              controller: lastNameController,
              onChanged: (value) => widget.cubit.updatePersonalInfo(
                firstName: firstNameController.text,
                lastName: value,
                dob: dateOfBirthController.text,
                personalImage: widget.cubit.personalImage ?? '',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S().pleaseEnterYourLastName;
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              ],
            ),
            verticalSpacing(10.h),
            TextFormEntry(
              hintText: S().dateOfBirth,
              textInputAction: TextInputAction.done,
              controller: dateOfBirthController,
              keyboardType: TextInputType.datetime,
              maxLength: 10,
              validator: DateValidator.validateDate,
              onChanged: (value) => widget.cubit.updatePersonalInfo(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                dob: value,
                personalImage: widget.cubit.personalImage ?? '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealDateInputFormatter(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
