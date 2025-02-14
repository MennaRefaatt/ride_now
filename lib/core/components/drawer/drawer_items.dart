import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/drawer/widgets/drawer_item.dart';
import 'package:ride_now/core/components/drawer/widgets/mode_switch_button.dart';
import 'package:ride_now/core/components/drawer/widgets/profile_section.dart';
import 'package:ride_now/core/helpers/enums/driver_status.dart';
import 'package:ride_now/core/helpers/enums/user_type.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/notifications/presentation/widgets/notification_icon.dart';
import '../../../features/auth/login/data/data_sources/firestore_service/firestore_service.dart';
import '../../../features/driver/driver_registration/data/models/driver_registration_model.dart';
import '../../di/di.dart';
import '../../helpers/safe_print.dart';
import '../../../generated/l10n.dart';

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
            ProfileSection(pictureUrl: pictureUrl, userName: userName),
            verticalSpacing(20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DrawerItem(
                      title: S().city,
                      icon: CupertinoIcons.car_detailed,
                      isActive: currentRoute == RoutingEndpoints.passengerHome,
                      onTap: () => navigateBasedOnMode(context),
                    ),
                    DrawerItem(
                      title: S().settings,
                      icon: CupertinoIcons.settings,
                      isActive: currentRoute == RoutingEndpoints.settings,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.settings),
                    ),
                    DrawerItem(
                      title: S().myTrips,
                      icon: Icons.edit_road,
                      isActive: currentRoute == RoutingEndpoints.myTripsScreen,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.myTripsScreen),
                    ),
                    DrawerItem(
                      title: S().wallet,
                      icon: Icons.wallet,
                      isActive: currentRoute == RoutingEndpoints.walletScreen,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.walletScreen,
                          arguments:
                              SharedPref.getString(key: MySharedKeys.userId)),
                    ),
                    DrawerItem(
                      title: S().privacyPolicy,
                      icon: Icons.private_connectivity,
                      isActive: currentRoute == RoutingEndpoints.privacyScreen,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.privacyScreen),
                    ),
                    DrawerItem(
                      title: S().notifications,
                      isNotificationIcon: true,
                      isActive: currentRoute == RoutingEndpoints.notifications,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, RoutingEndpoints.notifications);
                      },
                      child: NotificationIcon(),
                    ),
                    DrawerItem(
                      title: S().help,
                      icon: Icons.help,
                      isActive: currentRoute == RoutingEndpoints.helpScreen,
                      onTap: () => Navigator.pushReplacementNamed(
                          context, RoutingEndpoints.helpScreen),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            ModeSwitchButton(
                isDriverMode: isDriverMode!, onPressed: switchMode),
          ],
        ),
      ),
    );
  }

  void switchMode() {
    setState(() {
      isDriverMode = !isDriverMode!;
    });
    saveModeToFirestore(
        isDriverMode! ? UserType.driver.name : UserType.passenger.name);
    navigateBasedOnMode(context);
  }

  void saveModeToFirestore(String mode) {
    FirestoreService(sl(), sl()).saveUserModeToFirestore(mode);
    SharedPref.setString(key: MySharedKeys.type, value: mode);
  }

  void navigateBasedOnMode(BuildContext context) {
    if (isDriverMode!) {
      navigateBasedOnDriverStatus(context);
    } else {
      Navigator.pushReplacementNamed(context, RoutingEndpoints.passengerHome);
    }
  }

  void navigateBasedOnDriverStatus(BuildContext context) async {
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
            context, RoutingEndpoints.driverOnBoarding);
        return;
      }

      DriverRegistrationModel driver = DriverRegistrationModel.fromJson(
          driverSnapshot.data() as Map<String, dynamic>);

      if (driver.driverStatus == DriverStatus.pending.name) {
        Navigator.pushReplacementNamed(
            context, RoutingEndpoints.driverPendingScreen);
      } else if (driver.driverStatus == DriverStatus.accepted.name) {
        Navigator.pushReplacementNamed(context, RoutingEndpoints.driverHome);
      } else {
        Navigator.pushReplacementNamed(
            context, RoutingEndpoints.driverOnBoarding);
      }
    } catch (e) {
      safePrint("Error fetching driver status: $e");
      Navigator.pushReplacementNamed(
          context, RoutingEndpoints.driverNotEligibleScreen);
    }
  }
}
