import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: 'Ride',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
            ),
            children: const [
          TextSpan(
            text: 'N',
            style: TextStyle(color: AppColors.primary),
          ),
          TextSpan(
            text: 'ow',
            style: TextStyle(color: Colors.white),
          ),
        ]));
  }
}
