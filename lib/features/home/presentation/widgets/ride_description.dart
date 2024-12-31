import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';

import '../../../../core/components/app_network_image.dart';
import '../../../../core/theming/styles.dart';

class RideDescription extends StatelessWidget {
   const RideDescription(
      {super.key,
      required this.image,
      required this.text,
      required this.description,});
  final String image;
  final String text;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.semiGrey.withOpacity(0.3),
                child: Icon(
                  CupertinoIcons.xmark,
                  color: Colors.black,
                  size: 25.sp,
                ),
              ),
            ),
          ),
          verticalSpacing(20.h),
          AppNetworkImage(
            borderRadius: BorderRadius.circular(10.r),
            imageUrl: image,
            width: 150.w,
            height: 100.h,
          ),
          Text(
            text,
            style: TextStyles.font34BlackExtraBold,
          ),
          verticalSpacing(20.h),
          Text(
            description,
            style: TextStyles.font18BlackRegular,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
          verticalSpacing(20.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.semiGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(child: Text("S().ok", style: TextStyles.font18BlackRegular)),
            ),
          )
        ],
      ),
    );
  }
}
