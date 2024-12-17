import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_image.dart';

class SocialIcons extends StatelessWidget {
  final String path;
  final VoidCallback onTap;
  const SocialIcons({super.key, required this.path, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: AppImageAsset(path: path),
      ),
    );
  }
}
