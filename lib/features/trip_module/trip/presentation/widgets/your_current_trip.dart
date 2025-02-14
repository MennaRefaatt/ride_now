import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/spacing.dart';
import 'cancel_button.dart';

class YourCurrentTrip extends StatelessWidget {
  final String from;
  final String to;
  final bool isPassenger;
  const YourCurrentTrip({super.key, required this.from, required this.to, required this.isPassenger});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Current Trip",
          style: TextStyles.font24BlackBold,
        ),
        verticalSpacing(20.h),
        Row(
          children: [
            Icon(
              Icons.trip_origin,
              color: AppColors.red,
            ),
            horizontalSpacing(10.w),
            Expanded(
              child: Text(
                from,
                style: TextStyles.font18BlackRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(10.h),
        Row(
          children: [
            Icon(
              Icons.trip_origin,
              color: AppColors.primary,
            ),
            horizontalSpacing(10.w),
            Expanded(
              child: Text(
                to,
                style: TextStyles.font18BlackRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(20.h),
        CancelButton(
          isPassenger:isPassenger,
        ),
      ],
    );
  }
}
