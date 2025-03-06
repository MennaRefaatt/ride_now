import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';

class SelectedLocationContainer extends StatelessWidget {
  const SelectedLocationContainer({super.key, required this.address});
final String address;
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      top: 100,
      left: MediaQuery.of(context).size.width * 0.25,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.primary,
          ),
          child: Text(
            address.toString(),
            style: TextStyles.font18WhiteRegular,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
