import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/connection_lost.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/home_body.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/map_widget.dart';
import '../../../../../core/components/app_icon.dart';
import '../../../../../core/components/drawer_items.dart';
import '../../../../../core/di/di.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final bool _isHidden = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: _isHidden ? -100.w : 20.w,
              top: 40.h,
              curve: Curves.easeOut,
              child: AppIcon(
                withShadow: true,
                icon: Icons.more_horiz,
                backgroundColor: Colors.white,
                iconColor: Colors.black87,
                navigation: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
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
}
