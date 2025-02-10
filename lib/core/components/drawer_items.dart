import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/enums/driver_status.dart';
import 'package:ride_now/core/helpers/enums/user_type.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../features/auth/login/data/data_sources/firestore_service/firestore_service.dart';
import '../../features/driver/driver_registration/data/models/driver_registration_model.dart';
import '../di/di.dart';
import '../helpers/safe_print.dart';
import '../theming/app_colors.dart';
import '../theming/styles.dart';
import '../../generated/l10n.dart';

class DrawerItems extends StatefulWidget {
  const DrawerItems({super.key});

  @override
  State<DrawerItems> createState() => _DrawerItemsState();
}

class _DrawerItemsState extends State<DrawerItems> {
  final pictureUrl = SharedPref.getString(key: MySharedKeys.picture) ?? "";
  final userName = SharedPref.getString(key: MySharedKeys.userName) ?? "";
  bool? isDriverMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserMode();
  }

  void _loadUserMode() {
    String? mode = SharedPref.getString(key: MySharedKeys.type);
    setState(() {
      isDriverMode = mode == UserType.driver.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return Drawer(
      child: Container(
        margin: EdgeInsets.all(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(20),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(
                  context, RoutingEndpoints.profile),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.sp,
                    backgroundImage: pictureUrl.isNotEmpty &&
                            Uri.tryParse(pictureUrl)?.hasAbsolutePath == true
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
                  horizontalSpacing(10),
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
            verticalSpacing(20),
            Expanded(
              child: Column(
                children: [
                  drawerItem(
                    context: context,
                    title: S().city,
                    icon: CupertinoIcons.car_detailed,
                    destination: RoutingEndpoints.passengerHome,
                    isActive: currentRoute == RoutingEndpoints.passengerHome,
                onTap: () async {
                  if (isDriverMode!) {
                    String? userId = SharedPref.getString(key: MySharedKeys.userId);
                    if (userId == null) {
                      Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.driverNotEligibleScreen);
                      return;
                    }

                    try {
                      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
                          .collection("drivers")
                          .doc(userId)
                          .get();

                      if (!driverSnapshot.exists) {
                        Navigator.pushReplacementNamed(
                            context, RoutingEndpoints.driverNotEligibleScreen);
                        return;
                      }

                      DriverRegistrationModel driver = DriverRegistrationModel.fromJson(
                          driverSnapshot.data() as Map<String, dynamic>);

                      if (driver.driverStatus != DriverStatus.accepted.name) {
                        Navigator.pushReplacementNamed(
                            context, RoutingEndpoints.driverNotEligibleScreen);
                        return;
                      }

                      Navigator.pushReplacementNamed(context, RoutingEndpoints.driverHome);
                    } catch (e) {
                      safePrint("Error checking driver status: $e");
                      Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.driverNotEligibleScreen);
                    }
                  } else {
                    Navigator.pushReplacementNamed(context, RoutingEndpoints.passengerHome);
                  }
                },
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
              text: isDriverMode! ? S().passengerMode : S().driverMode,
              backgroundColor: AppColors.primary,
              onPressed: () {
                setState(() {
                  isDriverMode = !isDriverMode!;
                });
                saveModeToFirestore(isDriverMode! ? UserType.driver.name : UserType.passenger.name);

                if (isDriverMode!) {
                  navigateBasedOnDriverStatus();
                } else {
                  Navigator.pushReplacementNamed(context, RoutingEndpoints.passengerHome);
                }
              },
              borderRadius: 10.r,
              textStyle: TextStyles.font14BlackRegular,
            )
          ],
        ),
      ),
    );
  }

  void saveModeToFirestore(String mode) {
    FirestoreService(sl(), sl()).saveUserModeToFirestore(mode);
    SharedPref.setString(key: MySharedKeys.type, value: mode);
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
              ? AppColors.primary.withValues(alpha: 0.2)
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

  void navigateBasedOnDriverStatus() async {
    String? userId = SharedPref.getString(key: MySharedKeys.userId);
    if (userId == null) {
      Navigator.pushReplacementNamed(context, RoutingEndpoints.driverNotEligibleScreen);
      return;
    }

    try {
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
          .collection("drivers")
          .doc(userId)
          .get();

      if (!driverSnapshot.exists) {
        Navigator.pushReplacementNamed(context, RoutingEndpoints.driverNotEligibleScreen);
        return;
      }

      DriverRegistrationModel driver = DriverRegistrationModel.fromJson(
          driverSnapshot.data() as Map<String, dynamic>);

      if (driver.driverStatus == DriverStatus.pending.name) {
        Navigator.pushReplacementNamed(context, RoutingEndpoints.driverPendingScreen);
      } else if (driver.driverStatus == DriverStatus.accepted.name) {
        Navigator.pushReplacementNamed(context, RoutingEndpoints.driverHome);
      } else {
        Navigator.pushReplacementNamed(context, RoutingEndpoints.driverNotEligibleScreen);
      }
    } catch (e) {
      safePrint("Error fetching driver status: $e");
      Navigator.pushReplacementNamed(context, RoutingEndpoints.driverNotEligibleScreen);
    }
  }
}
