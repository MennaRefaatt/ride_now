import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class MoreOptions extends StatelessWidget {
  const MoreOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showModalBottomSheet(
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(15.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "S().Options",
                      style: TextStyles.font24BlackBold,
                      textAlign: TextAlign.center,
                    )),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Colors.grey.shade200,
                        ),
                        child: Icon(CupertinoIcons.xmark),
                      ),
                    ),
                  ],
                ),
                verticalSpacing(30.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "S().moreThan4Passengers",
                        style: TextStyles.font18BlackRegular,
                      ),
                    ),
                    CupertinoSwitch(
                      value: true,
                      onChanged: (bool value) {},
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                AppTextFormField(
                  hintText: "S().comment",
                  withHint: true,
                  controller: TextEditingController(),
                  borderRadius: BorderRadius.circular(15.r),
                  backgroundColor: Colors.grey.shade200,
                  borderColor: Colors.transparent,
                  isFilled: true,
                  hintStyle: TextStyles.font18BlackRegular.copyWith(
                    color: Colors.grey.shade800,
                  ),
                ),
                AppButton(
                  text: "S().apply",
                  width: double.infinity,
                  backgroundColor: AppColors.primary,
                  borderRadius: 15.r,
                  onPressed: () {},
                  textStyle: TextStyles.font18BlackRegular,
                ),
              ],
            ),
          );
        },
        context: context,
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      child: Icon(CupertinoIcons.location),
    );
  }
}
