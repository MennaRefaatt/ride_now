import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theming/app_colors.dart';

class TripProgressBar extends StatelessWidget {
  final int timeRemaining;

  const TripProgressBar({super.key, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: timeRemaining > 0 ? timeRemaining / 30 : 0.0,
      backgroundColor: Colors.grey.shade200,
      color: AppColors.primary,
      minHeight: 6.h,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.r),
        topRight: Radius.circular(30.r),
      ),
    );
  }
}
