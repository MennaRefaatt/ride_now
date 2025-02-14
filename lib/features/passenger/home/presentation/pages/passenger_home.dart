import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/connection_lost.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/home_body.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/map_widget.dart';
import '../../../../../core/components/app_icon.dart';
import '../../../../../core/components/drawer/drawer_items.dart';
import '../../../../../core/di/di.dart';
import '../../../../notifications/data/models/notification_model.dart';
import '../../../../notifications/presentation/manager/notification_cubit.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  bool _isHidden = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _updateHiddenState(bool isHidden) {
    setState(() {
      _isHidden = isHidden;
    });
  }

  final homeCubit = HomeCubit(homeRepoBase: sl());
  final locationCubit = LocationCubit(sl(), sl(), sl());
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locationCubit..fetchUserLocation(),
        ),
        BlocProvider(
          create: (context) => homeCubit..getCategoriesAndTrips(),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerItems(),
        body: Stack(
          children: [
            MapWidget(
              homeCubit: homeCubit,
              isHidden: _isHidden,
              updateHiddenState: _updateHiddenState,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: _isHidden ? -100.w : 20.w,
              top: 40.h,
              curve: Curves.easeOut,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AppIcon(
                    withShadow: true,
                    icon: Icons.more_horiz,
                    backgroundColor: Colors.white,
                    iconColor: Colors.black87,
                    navigation: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  BlocBuilder<NotificationsCubit, List<NotificationModel>>(
                    builder: (context, notifications) {
                      int unreadCount =
                          notifications.where((n) => !n.isRead).length;
                      return Visibility(
                        visible: unreadCount > 0,
                        child: Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            HomeBody(
              homeCubit: homeCubit,
              isHidden: _isHidden,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConnectionAwareWidget(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    homeCubit.close();
    locationCubit.close();
    super.dispose();
  }
}
