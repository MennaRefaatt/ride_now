import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/pick_image.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/widgets/text_form_entry.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import 'image_type_enum.dart';

class PersonalDocumentsPage extends StatefulWidget {
  const PersonalDocumentsPage({super.key, required this.cubit});
  final DriverRegistrationCubit cubit;

  @override
  State<PersonalDocumentsPage> createState() => _PersonalDocumentsPageState();
}

class _PersonalDocumentsPageState extends State<PersonalDocumentsPage> {
  final TextEditingController _idNumberController = TextEditingController();
  @override
  void initState() {
    _idNumberController.text = widget.cubit.idNumber ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S().personalDocuments,
              style: theme.brightness == Brightness.dark ? TextStyles.font24WhiteBold :TextStyles.font24BlackBold,
            ),
            verticalSpacing(20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PickImage(
                    text: S().nationalId,
                    image: widget.cubit.nationalIdImage ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.nationalIdImage);
                      setState(() {});
                    },
                  ),
                  PickImage(
                    text: S().backSideOfId,
                    image: widget.cubit.backOfIdImage ?? '',
                    onTap: () async {
                      await widget.cubit.pickImage(ImageType.backOfIdImage);
                      setState(() {});
                    },
                  ),
                  PickImage(
                    text: S().criminalStatus,
                    image: widget.cubit.criminalStatusImage ?? '',
                    onTap: () async {
                      await widget.cubit
                          .pickImage(ImageType.criminalStatusImage);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            verticalSpacing(20),
            TextFormEntry(
              onChanged: (value) => widget.cubit.updateDocumentsInfo(
                idNumber: value,
                nationalIdImage: widget.cubit.nationalIdImage ?? '',
                backOfIdImage: widget.cubit.backOfIdImage ?? '',
                criminalStatusImage: widget.cubit.criminalStatusImage ?? '',
              ),
              hintText: S().idNumber,
              maxLength: 14,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _idNumberController,
              validator: NationalIdValidator.validateNationalId,
            ),
          ],
        ),
      ),
    );
  }
}
