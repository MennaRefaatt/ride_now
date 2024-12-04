import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/auth/login/presentation/widgets/google_facebook_buttons.dart';
import 'package:ride_now/features/auth/login/presentation/widgets/login_forms.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.sp),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            verticalSpacing(100.h),
            Text(
              S().loginText,
              style: TextStyles.font34BlackExtraBold,
            ),
            verticalSpacing(20.h),
            const LoginForms(),
            verticalSpacing(20.h),
            InkWell(
              onTap: () {},
              child: Text(S().forgotPassword,
                  style: TextStyles.font14BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      decorationStyle: TextDecorationStyle.solid,
                      decoration: TextDecoration.underline)),
            ),
            verticalSpacing(20.h),
            AppButton(
                text: S().login,
                backgroundColor: AppColors.primary,
                onPressed: () => Navigator.pushReplacementNamed(
                    context, RoutingEndpoints.home),
                width: double.infinity,
                textStyle: TextStyles.font14BlackRegular),
            verticalSpacing(20.h),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutingEndpoints.register);
              },
              child: Center(
                child: RichText(
                    text: TextSpan(
                        text: S().dontHaveAnAccount,
                        style: TextStyles.font14BlackRegular,
                        children: [
                      TextSpan(
                        text: S().register,
                        style: TextStyles.font14BlackRegular.copyWith(
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.solid,
                            decoration: TextDecoration.underline),
                      )
                    ])),
              ),
            ),
            verticalSpacing(20.h),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "-----------------------------",
                      style: TextStyles.font18BlackRegular.copyWith(
                        color: Colors.grey.shade300,
                        fontSize: 20.sp,
                      ),
                      children: [
                    TextSpan(
                        text: S().or, style: TextStyles.font14BlackRegular),
                    TextSpan(
                        text: "-----------------------------",
                        style: TextStyles.font18BlackRegular.copyWith(
                          color: Colors.grey.shade300,
                          fontSize: 20.sp,
                        )),
                  ])),
            ),
            verticalSpacing(20.h),
            const GoogleFacebookButtons()
          ]),
        ),
      ),
    );
  }
}
