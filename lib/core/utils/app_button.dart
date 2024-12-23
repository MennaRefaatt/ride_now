import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  AppButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    required this.textStyle,
    this.height,
    this.width,
    this.borderRadius,
  });
  double? height;
  double? width;
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final double? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: SizedBox(
        width: width?.w ?? 200.w,
        height: height?.h ?? 50.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius != null
                  ? BorderRadius.circular(borderRadius!)
                  : BorderRadius.circular(30.r),
            ),
          ),
          child: Text(
            text,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
