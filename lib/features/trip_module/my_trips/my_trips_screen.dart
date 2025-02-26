import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/theming/styles.dart';
import '../../../core/components/drawer/drawer_items.dart';
import '../../../core/di/di.dart';
import '../../../core/theming/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../passenger/home/presentation/manager/home_cubit.dart';
import '../trip/data/models/trip_model.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final homeCubit = HomeCubit(homeRepoBase: sl());
  List<TripModel> uniqueTrips = [];
  Set<String> uniqueLatLngs = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => homeCubit..getTrips(),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: DefaultAppBar(
              text: S().myTrips,
              withDivider: false,
            )),
        drawer: DrawerItems(),
        body: Container(
          margin: EdgeInsets.all(15.sp),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is GetRecentTripsLoaded) {
                uniqueTrips = state.trips;
                return ListView.builder(
                  itemCount: uniqueTrips.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.sp),
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: theme.brightness == Brightness.light
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.primary.withValues(alpha: 0.3),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: AppColors.primary
                                          .withValues(alpha: 0.2),
                                      child: const Icon(
                                        Icons.trip_origin,
                                        color: AppColors.primary,
                                      )),
                                  Expanded(
                                    child: Text(
                                      "From: ${uniqueTrips[index].from}",
                                      style: theme.brightness == Brightness.light
                                          ? TextStyles.font18BlackBold
                                          : TextStyles.font18WhiteBold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          AppColors.red.withValues(alpha: 0.2),
                                      child: const Icon(
                                        Icons.trip_origin,
                                        color: AppColors.red,
                                      )),
                                  Expanded(
                                    child: Text(
                                      "To: ${uniqueTrips[index].to}",
                                      style: theme.brightness == Brightness.light
                                          ? TextStyles.font18BlackBold
                                          : TextStyles.font18WhiteBold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Date: ${uniqueTrips[index].dateTime.day}/${uniqueTrips[index].dateTime.month}/${uniqueTrips[index].dateTime.year}",
                                style: theme.brightness == Brightness.light
                                    ? TextStyles.font18BlackRegular
                                    : TextStyles.font18WhiteRegular,
                              ),
                              Text(
                                "Time: ${uniqueTrips[index].dateTime.hour}:${uniqueTrips[index].dateTime.minute}",
                                style: theme.brightness == Brightness.light
                                    ? TextStyles.font18BlackRegular
                                    : TextStyles.font18WhiteRegular,
                              ),
                              Text(
                                "Cost: ${uniqueTrips[index].price.split(".")[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${uniqueTrips[index].paymentMethod}",
                                style: theme.brightness == Brightness.light
                                    ? TextStyles.font18BlackRegular
                                    : TextStyles.font18WhiteRegular,
                              ),
                            ],
                          ),
                        ),
                        if (index != uniqueTrips.length - 1)
                          Divider(
                            color: Colors.grey.shade300,
                          ),
                      ],
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
