import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/drawer/drawer_items.dart';
import 'package:ride_now/features/driver/driver_home/presentation/widgets/trip_request_dialogue.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final tripCubit = TripCubit(
      acceptTripUseCase: sl(),
      createTripUseCase: sl(),
      getTripsUseCase: sl(),
      getTripDetailsUseCase: sl(),cancelTripUseCase: sl());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => tripCubit..getTrips(),
      child: Scaffold(
        backgroundColor: AppColors.semiGrey.withValues(alpha: 0.1),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: DefaultAppBar(
              text: S().passengerRequests,
              withDivider: false,
            )),
        drawer: DrawerItems(),
        body: Container(
          padding: EdgeInsets.all(20.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TripRequestsDialogue(tripCubit: tripCubit,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
