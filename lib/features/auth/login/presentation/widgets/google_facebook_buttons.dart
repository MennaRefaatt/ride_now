import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/utils/app_image.dart';

class GoogleFacebookButtons extends StatelessWidget {
  const GoogleFacebookButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
              height: 70.h,
              width: double.infinity,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppImage(path: "icons/google.png"),
                  horizontalSpacing(10.w),
                  // Text(S().signInWithGoogle,
                  //     style: TextStyles.font14BlackRegular),
                ],
              )
          ),
        ),
        verticalSpacing(20.h),
        InkWell(
          onTap: () {},
          child: Container(
              height: 70.h,
              width: double.infinity,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppImage(path: "icons/facebook.png"),
                  horizontalSpacing(10.w),
                  // Text(S().signInWithFacebook,
                  //     style: TextStyles.font14BlackRegular),
                ],
              )
          ),
        )
      ],
    );
  }
}
