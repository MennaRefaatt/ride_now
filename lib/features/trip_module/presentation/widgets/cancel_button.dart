import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/theming/styles.dart';
import '../../../../../core/theming/app_colors.dart';
import '../manager/trip_cubit.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listener: (context, state) {
        if (state is CancelTripSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip canceled successfully!')),
          );
          Navigator.pop(context);
        } else if (state is CancelTripError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error canceling trip: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        String? tripId;
        if (state is GetTripDetailsLoaded) {
          tripId = state.trip.tripId;
        }
        return Visibility(
          child: GestureDetector(
            onTap: () {
              if (tripId != null && tripId.isNotEmpty) {
                context
                    .read<TripCubit>()
                    .cancelTrip(tripId)
                    .then((value) => Navigator.pushReplacementNamed(
                          context,
                          RoutingEndpoints.passengerHome,
                        ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Trip ID is not available')),
                );
              }
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10.sp),
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: AppColors.semiGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "Cancel",
                  style:
                      TextStyles.font18WhiteBold.copyWith(color: AppColors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
