import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_image.dart';

class WhereToBar extends StatelessWidget {
  const WhereToBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          verticalSpacing(50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "S().carTaxi",
                      style: TextStyles.font12WhiteBold,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white10,
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          verticalSpacing(50.h),
          Container(
            constraints: const BoxConstraints(
                minWidth: double.infinity), // Add constraints
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const AppImage(
                      path: "images/dot.png",
                      height: 20,
                    ),
                    Text(
                      "|",
                      style: TextStyles.font12WhiteBold.copyWith(
                          fontSize: 40, fontWeight: FontWeight.w300),
                    ),
                    const Icon(
                      CupertinoIcons.location_solid,
                      color: Colors.white,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(
                        controller: TextEditingController(),
                        borderRadius: BorderRadius.circular(15.r),
                        backgroundColor: Colors.white10,
                        borderColor: Colors.transparent,
                        isFilled: true,
                        withHint: true,
                        hintStyle: TextStyles.font12WhiteRegular,
                        hintText: "S().fromWhere",
                        keyboardType: TextInputType.text,
                      ),
                      verticalSpacing(20.h),
                      AppTextFormField(
                        controller: TextEditingController(),
                        borderRadius: BorderRadius.circular(15.r),
                        backgroundColor: Colors.white10,
                        borderColor: Colors.transparent,
                        isFilled: true,
                        hintStyle: TextStyles.font12WhiteRegular,
                        withHint: true,
                        hintText: "S().whereTo",
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
