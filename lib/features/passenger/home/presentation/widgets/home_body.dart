import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../maps/presentation/manager/location_cubit.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../manager/home_cubit.dart';
import '../widgets/ride_categories.dart';
import '../widgets/where_to_bar.dart';

class HomeBody extends StatelessWidget {
  HomeBody({super.key, required this.homeCubit, required this.isHidden});
  late bool isHidden;
  final HomeCubit homeCubit;
  @override
  Widget build(BuildContext context) {
    void _openEnterYourRouteFromOrderButton(BuildContext context) {
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
                children: [
                  RideCategories(
                    categories: categories,
                  ),
                  WhereToBar(
                    cubit: homeCubit,
                    lastTrips: trips,
                    toLatLng: homeCubit.toLatLng,
                  ),
                  AppButton(
                    text: "Order",
                    textStyle: TextStyles.font14BlackRegular,
                    onPressed: () {
                      if (homeCubit.fromController.text.isEmpty ||
                          homeCubit.toController.text.isEmpty) {
                        _openEnterYourRouteFromOrderButton(context);
                      }
                      final locationState = context.read<LocationCubit>().state;
                      if (locationState is LocationLoaded) {
                        homeCubit.fromLatLng = LatLng(
                          locationState.position.latitude,
                          locationState.position.longitude,
                        );
                      }
                      safePrint(
                          "From: ${homeCubit.fromLatLng}, To: ${homeCubit.toLatLng}");

                      Navigator.pushNamed(context, RoutingEndpoints.checkOut,
                          arguments: CheckOutArgs(
                            fromAddress: homeCubit.fromController.text,
                            toAddress: homeCubit.toController.text,
                            fromLatLng: homeCubit.fromLatLng!,
                            toLatLng: homeCubit.toLatLng!,
                          ));
                    },
                    backgroundColor: AppColors.primary,
                    width: double.infinity,
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
