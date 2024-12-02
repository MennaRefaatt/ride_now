import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/components/app_text_form_field.dart';
import '../../../../../core/forms/user_data_form_validators.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../generated/l10n.dart';

class RegisterForms extends StatelessWidget {
  const RegisterForms({super.key});

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
          textInputAction: TextInputAction.next,
          controller: userDataFormValidators.passwordController,
          title: S().password,
          hintText: S().enterYourPassword,
          withHint: true,
          withTitle: true,
          validator: (value) => userDataFormValidators.validatePassword(
            userDataFormValidators.passwordController.text,
          ),
        ),
        verticalSpacing(20.h),
        AppTextFormField(
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          controller: userDataFormValidators.confirmPasswordController,
          title: S().confirmPassword,
          hintText: S().enterYourConfirmPassword,
          withHint: true,
          withTitle: true,
          validator: (value) => userDataFormValidators.validateConfirmPassword(
            userDataFormValidators.confirmPasswordController.text,
          ),
        ),
      ],
    );
  }
}
