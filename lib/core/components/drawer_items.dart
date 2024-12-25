import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../theming/app_colors.dart';
import '../theming/styles.dart';
import '../../generated/l10n.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final pictureUrl = SharedPref.getString(key: MySharedKeys.picture) ?? "";
    final userName = SharedPref.getString(key: MySharedKeys.userName) ?? "";

    return Drawer(
      child: Container(
        margin: EdgeInsets.all(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(20.h),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(
                  context, RoutingEndpoints.profile),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.sp,
                    backgroundImage: pictureUrl.isNotEmpty && Uri.tryParse(pictureUrl)?.hasAbsolutePath == true
                        ? NetworkImage(pictureUrl)
                        : null,
                    child: Visibility(
                      visible: pictureUrl.isEmpty,
                      child: Text(
                        userName.isNotEmpty ? userName[0] : '',
                        style: TextStyles.font18BlackRegular,
                      ),
                    ),
                  ),
                  horizontalSpacing(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SharedPref.getString(key: MySharedKeys.userName)!,
                          style: TextStyles.font14BlackRegular,
                        ),
                        Text(
                          SharedPref.getString(key: MySharedKeys.email)!,
                          style: TextStyles.font12BlackRegular,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.navigate_next),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  drawerItem(
                    context: context,
                    title: S().city,
                    icon: CupertinoIcons.car_detailed,
                    destination: RoutingEndpoints.home,
                    isActive: currentRoute == RoutingEndpoints.home,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, RoutingEndpoints.home),
                  ),
                  drawerItem(
                    context: context,
                    title: S().settings,
                    icon: CupertinoIcons.settings,
                    destination: RoutingEndpoints.settings,
                    isActive: currentRoute == RoutingEndpoints.settings,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, RoutingEndpoints.settings),
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
          color: isActive
              ? AppColors.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? AppColors.primary : Colors.grey),
            horizontalSpacing(10.w),
            Text(
              title,
              style: isActive
                  ? TextStyles.font18BlackRegular
                      .copyWith(color: AppColors.primary)
                  : TextStyles.font18BlackRegular,
            ),
          ],
        ),
      ),
    );
  }
}
