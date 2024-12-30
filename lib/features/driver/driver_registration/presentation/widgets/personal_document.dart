import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';

class PersonalDocumentsPage extends StatefulWidget {
  const PersonalDocumentsPage({super.key, required this.cubit});
  final DriverRegistrationCubit cubit;

  @override
  State<PersonalDocumentsPage> createState() => _PersonalDocumentsPageState();
}

class _PersonalDocumentsPageState extends State<PersonalDocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'S().personalDocuments',
              style: TextStyles.font24BlackBold,
            ),
            verticalSpacing(20.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PickImage(
                      text: "S().national ID",
                      image: widget.cubit.nationalIdImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage();
                        setState(() {});
                      }),
                  PickImage(
                      text: "S().backSide Of ID",
                      image: widget.cubit.backOfIdImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage();
                        setState(() {});
                      }),
                  PickImage(
                      text: "S().criminal status record",
                      image: widget.cubit.criminalStatusImage ?? '',
                      onTap: () async {
                        await widget.cubit.pickImage();
                        setState(() {});
                      }),
                ],
              ),
            ),
            verticalSpacing(20.h),
            TextFormEntry(
              onChanged: (value) => widget.cubit.updateDocumentsInfo(
                value,
                widget.cubit.nationalIdImage ?? '',
                widget.cubit.backOfIdImage ?? '',
                widget.cubit.criminalStatusImage ?? '',
              ),
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
