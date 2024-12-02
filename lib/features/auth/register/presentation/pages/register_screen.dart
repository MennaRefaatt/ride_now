import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../widgets/register_forms.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.sp),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            verticalSpacing(100.h),
            Text(
              S().createAccount,
              style: TextStyles.font34BlackExtraBold,
            ),
            verticalSpacing(20.h),
            const RegisterForms(),
            verticalSpacing(20.h),
            AppButton(
                text: S().register,
                backgroundColor: AppColors.primary,
                onPressed: () {},
                width: double.infinity,
                textStyle: TextStyles.font14BlackRegular),
            verticalSpacing(20.h),
            ]),
        ),
      ),
    );
  }
}
