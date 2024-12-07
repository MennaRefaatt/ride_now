import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppImageAsset extends StatelessWidget {
  const AppImageAsset({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit,
    this.borderRadius,
  });

  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0.r),
      child: Image.asset(
        "assets/$path",
        height: height ?? 50.h,
        width: width ?? 50.w,
        fit: fit,
      ),
    );
  }
}
