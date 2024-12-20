import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/auth/login/presentation/widgets/google_facebook_buttons.dart';
import 'package:ride_now/features/auth/login/presentation/widgets/login_forms.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
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
            InkWell(
              onTap: () => Navigator.pushNamed(context, RoutingEndpoints.otp),
              child: Text(
                S().loginText,
                style: TextStyles.font34BlackExtraBold,
              ),
            ),
            verticalSpacing(20.h),
            ProviderScope(child: const LoginForms()),
            verticalSpacing(20.h),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "  ----------------------- ",
                  style: TextStyles.font18BlackRegular.copyWith(
                    color: Colors.grey.shade300,
                    fontSize: 20.sp,
                  ),
                  children: [
                    TextSpan(
                      text: S().or,
                      style: TextStyles.font14BlackRegular,
                    ),
                    TextSpan(
                      text: "  ----------------------- ",
                      style: TextStyles.font18BlackRegular.copyWith(
                        color: Colors.grey.shade300,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacing(20.h),
            ProviderScope(child: const GoogleFacebookButtons())
          ]),
        ),
      ),
    );
  }
}
