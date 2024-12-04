import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../core/services/routing/routing_endpoints.dart';
import '../../../../core/theming/styles.dart';

class SearchBarr extends StatelessWidget {
  const SearchBarr({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150,
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, RoutingEndpoints.whereTo),
              child: AppTextFormField(
                enable: false,
                withShadow: true,
                contentPadding: EdgeInsets.all(20.r),
                controller: TextEditingController(),
                hintText: "S().whereTo",
                hintStyle: const TextStyle(color: AppColors.primaryLight),
                withHint: true,
                backgroundColor: Colors.white,
                isFilled: true,
                borderColor: Colors.white,
                prefixIcon: const Icon(
                  CupertinoIcons.location_solid,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
            ),
            Positioned(
              top: 6,
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, RoutingEndpoints.openMaps),
                child: Container(
                  margin: EdgeInsets.all(5.sp),
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      "S().openMap",
                      style: TextStyles.font14BlackRegular,
                    ),
                    horizontalSpacing(10.w),
                    const Icon(
                      CupertinoIcons.map_fill,
                      color: AppColors.primary,
                      size: 25,
                    )
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
