import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';
import '../widgets/ride_categories.dart';
import '../widgets/where_to_bar.dart';

class HomeBody extends StatelessWidget {
  HomeBody({super.key, required this.homeCubit, required this.isHidden});
  late bool isHidden;
  final HomeCubit homeCubit;
  void openEnterYourRouteFromOrderButton(BuildContext context) {
    final locationState = context.read<LocationCubit>().state;
    final homeState = context.read<HomeCubit>().state;
    String fromText = 'S().From';
    Color backgroundColor = Colors.grey.shade200;
    List<TripModel> trips = [];

    if (locationState is LocationLoaded) {
      fromText = locationState.address;
      backgroundColor = Colors.transparent;
    }
    if (homeState is GetRecentTripsLoaded) {
      trips = homeState.trips;
    }
    homeCubit.openEnterYourRoute(context, homeCubit.fromFocusNode,
        homeCubit.toFocusNode, fromText, backgroundColor, homeCubit, trips);
  }

  double? cost;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          isHidden ? 300.h : 0,
          0,
        ),
        width: double.infinity,
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.r),
            topLeft: Radius.circular(40.r),
          ),
        ),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return CircularProgressIndicator();
            } else if (state is HomeLoaded) {
              final categories = state.categories;
              final trips = state.trips;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RideCategories(
                    categories: categories,
                  ),
                  WhereToBar(
                    cubit: homeCubit,
                    lastTrips: trips,
                    toLatLng: homeCubit.toLatLng,
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: state.cost != null,
                        child: Container(
                          padding: EdgeInsets.all(10.sp),
                          margin: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.money_dollar,
                                color: AppColors.primary,
                                size: 30.sp,
                              ),
                              horizontalSpacing(5),
                              Text(
                                state.cost != null
                                    ? state.cost!.toStringAsFixed(2)
                                    : '',
                                style: TextStyles.font18BlackBold,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          text: "Order",
                          textStyle: TextStyles.font18BlackBold,
                          onPressed: () async {
                            if (homeCubit.fromController.text.isEmpty ||
                                homeCubit.toController.text.isEmpty) {
                              openEnterYourRouteFromOrderButton(context);
                            }
                            final locationState =
                                context.read<LocationCubit>().state;
                            if (locationState is LocationLoaded) {
                              homeCubit.fromLatLng = LatLng(
                                locationState.position.latitude,
                                locationState.position.longitude,
                              );
                            }
                            safePrint(
                                "From: ${homeCubit.fromLatLng}, To: ${homeCubit.toLatLng}");

                            final result = await Navigator.pushNamed(
                                context, RoutingEndpoints.checkOut,
                                arguments: CheckOutArgs(
                                  fromAddress: homeCubit.fromController.text,
                                  toAddress: homeCubit.toController.text,
                                  fromLatLng: homeCubit.fromLatLng!,
                                  toLatLng: homeCubit.toLatLng!,
                                ));
                            if (result != null) {
                              double updatedCost = result as double;
                              homeCubit.updateCost(
                                  updatedCost); // Update the cost in the cubit
                              safePrint("Cost: $updatedCost");
                            }
                          },
                          backgroundColor: AppColors.primary,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  )
                ],
              );
            } else if (state is HomeError) {
              return Text('Error: ${state.message}');
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
