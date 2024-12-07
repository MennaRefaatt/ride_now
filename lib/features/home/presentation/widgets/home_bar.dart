import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_name.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class HomeBar extends StatelessWidget {
  const HomeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 250.h,
      width: double.infinity,
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),

          ),
          color: AppColors.primaryLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacing(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppName(),
              InkWell(
                onTap: () {},
                child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 30.sp,
                    )),
              )
            ],
          ),
          verticalSpacing(20.h),
          Text("S().yourWallet",
              style: TextStyles.font12WhiteBold.copyWith(
                fontWeight: FontWeight.w300,
              )),
          Text("\$1,895.10",
              style: TextStyles.font18WhiteMedium.copyWith(
                fontSize: 23.sp,
              )),
        ],
      ),
    );
  }
}
