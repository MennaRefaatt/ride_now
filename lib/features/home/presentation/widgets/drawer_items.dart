import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return Drawer(
      child: Container(
        margin: EdgeInsets.all(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(20.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 30.sp,
                  backgroundImage: const NetworkImage(
                    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  ),
                ),
                horizontalSpacing(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "S().Username",
                        style: TextStyles.font14BlackRegular,
                      ),
                      Text(
                        "S().Email",
                        style: TextStyles.font12BlackRegular,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.navigate_next),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  drawerItem(
                    context: context,
                    title: "City",
                    icon: CupertinoIcons.car_detailed,
                    destination: RoutingEndpoints.home,
                    isActive: currentRoute == RoutingEndpoints.home,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.home);
                    },
                  ),
                  drawerItem(
                    context: context,
                    title: "Settings",
                    icon: CupertinoIcons.settings,
                    destination: RoutingEndpoints.settings,
                    isActive: currentRoute == RoutingEndpoints.settings,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.settings);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            AppButton(
              text: "S().Driver mode",
              backgroundColor: AppColors.primary,
              onPressed: () {},
              borderRadius: 10.r,
              textStyle: TextStyles.font14BlackRegular,
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String destination,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.primary : Colors.grey),
            horizontalSpacing(10.w),
            Text(
              title,
              style: isActive
                  ? TextStyles.font18BlackRegular.copyWith(color: AppColors.primary)
                  : TextStyles.font18BlackRegular,
            ),
          ],
        ),
      ),
    );
  }
}
