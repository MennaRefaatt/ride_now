import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  const AppSvg({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.color,
  });

  final String path;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/svg/$path.svg",
      color: color ?? Colors.black,
      height: height ?? 50.h,
      width: width ?? 50.w,
    );
  }
}
