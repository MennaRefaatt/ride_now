import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart'; // Make sure this is correct
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.verificationId,
  });
  final String verificationId;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "S().OTP code",
              style: TextStyles.font34BlackExtraBold,
            ),
            verticalSpacing(20.h),
            OtpTextField(
              numberOfFields: 6,
              focusedBorderColor: AppColors.primary,
              showFieldAsBox: true,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                setState(() {
                  isLoading = true;
                });
                verifyOtp(verificationCode);
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            verticalSpacing(20.h),
            isLoading
                ? const CircularProgressIndicator()
                : AppButton(
                    text: "S().verify",
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      verifyOtp(otpController.text);
                    },
                    textStyle: TextStyles.font18BlackRegular)
          ],
        ),
      ),
    );
  }

  Future<void> verifyOtp(String otp) async {
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(cred);

      Navigator.pushReplacementNamed(context, RoutingEndpoints.passengerHome);
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
