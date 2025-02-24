import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import '../../../theming/app_colors.dart';
import '../../../theming/styles.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool isNotificationIcon;
  final Widget? child;
  const DrawerItem(
      {required this.title,
      this.icon,
      required this.isActive,
      required this.onTap,
      this.child,
      this.isNotificationIcon = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            isNotificationIcon
                ? child!
                : Icon(icon, color: isActive ? AppColors.primary : Colors.grey),
            horizontalSpacing(10.w),
            Text(title,
                style: isActive
                    ? TextStyles.font18BlackRegular
                        .copyWith(color: AppColors.primary)
                    : TextStyles.font18BlackRegular),
          ],
        ),
      ),
    );
  }
}
