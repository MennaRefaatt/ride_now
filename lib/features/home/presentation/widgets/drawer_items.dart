import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.navigate_next)
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  drawerItem(title: "City", icon: CupertinoIcons.car_detailed),
                  drawerItem(title: "Settings", icon: CupertinoIcons.settings),
                  drawerItem(title: "Help", icon: Icons.help),
                  drawerItem(
                      title: "Profile", icon: CupertinoIcons.profile_circled),
                  drawerItem(title: "Payment", icon: Icons.payment),
                  drawerItem(
                      title: "Safety", icon: Icons.health_and_safety_outlined),
                  drawerItem(title: "My Trips", icon: Icons.cable_rounded),
                  drawerItem(
                      title: "Notifications", icon: Icons.notifications_on_sharp),
                  drawerItem(title: "Logout", icon: Icons.logout, color: true),
                ],
              ),
            ),
            Divider(),
            AppButton(
                text: "S().Driver mode",
                backgroundColor: AppColors.primary,
                onPressed: () {},
                borderRadius: 10.r,
                textStyle: TextStyles.font14BlackRegular),
          ],
        ),
      ),
    );
  }
}

Widget drawerItem(
    {required String title, required IconData icon, bool? color}) {
  return Container(
    margin: EdgeInsets.all(15.sp),
    child: Row(
      children: [
        Icon(icon, color: color != null ? Colors.red : AppColors.primary),
        horizontalSpacing(10.w),
        Text(
          title,
          style: TextStyles.font18BlackRegular,
        ),
      ],
    ),
  );
}
