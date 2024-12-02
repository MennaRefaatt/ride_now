
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/forms/user_data_form_validators.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import '../../../../../generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class LoginForms extends StatelessWidget {
  const LoginForms({super.key});

  @override
  Widget build(BuildContext context) {
    UserDataFormValidators userDataFormValidators = UserDataFormValidators();
    return Column(
      children: [
        AppTextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: userDataFormValidators.emailController,
          title: S().email,
          hintText: S().enterYourEmail,
          withHint: true,
          withTitle: true,
          validator: (value) => userDataFormValidators.validateEmail(
            userDataFormValidators.emailController.text,
          ),
        ),
        verticalSpacing(20.h),
        AppTextFormField(
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          controller: userDataFormValidators.passwordController,
          title: S().password,
          hintText: S().enterYourPassword,
          withHint: true,
          withTitle: true,
          validator: (value) => userDataFormValidators.validatePassword(
            userDataFormValidators.passwordController.text,
          ),
        ),
      ],
    );
  }
}
