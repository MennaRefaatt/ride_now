import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/shared_pref.dart';
import '../helpers/shared_pref_keys.dart';
import '../theming/app_colors.dart';
import '../utils/app_svg.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar(
      {super.key,
      required this.text,
      required this.cartIcon,
      required this.backArrow});
  final String text;
  final bool? cartIcon;
  final bool? backArrow;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      padding: EdgeInsets.all(15.sp),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: backArrow == true,
            child: IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: SharedPref.getBoolean(key: MySharedKeys.isDarkMode)
                  ? Colors.white
                  : AppColors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Visibility(
            visible: cartIcon == true,
            child: InkWell(
              onTap: (){},
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: AppSvg(
                  path: "shopping-cart",
                  height: 20.h,
                  color: SharedPref.getBoolean(key: MySharedKeys.isDarkMode)
                      ? Colors.white
                      : AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
