import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/theming/styles.dart';
import '../../../../../core/components/app_entry_point.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../generated/l10n.dart';
import '../manager/trip_cubit.dart';

class CancelButton extends StatelessWidget {
  const CancelButton(
      {super.key, required this.isPassenger, required this.tripId});
  final bool isPassenger;
  final String tripId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(listener: (context, state) {
      if (state is CancelTripSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip canceled successfully!')),
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          safePrint("Checking navigator state...");

          if (appNavKey.currentState != null) {
            safePrint(
                "✅ Navigating to ${isPassenger ? RoutingEndpoints.passengerHome : RoutingEndpoints.driverHome}");
            appNavKey.currentState!.pushReplacementNamed(
              isPassenger
                  ? RoutingEndpoints.passengerHome
                  : RoutingEndpoints.driverHome,
            );
          } else {
            safePrint(
                "🚨 Navigation failed: appNavKey is null. Trying context-based navigation...");
            Navigator.of(context).pushReplacementNamed(
              isPassenger
                  ? RoutingEndpoints.passengerHome
                  : RoutingEndpoints.driverHome,
            );
          }
        });
      } else if (state is CancelTripError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error canceling trip: ${state.message}')),
        );
      }
    }, builder: (context, state) {
      if (tripId.isEmpty) {
        return Visibility(
          visible: false,
          child: CircularProgressIndicator(),
        );
      }

      return Visibility(
        visible: tripId.isNotEmpty,
        child: GestureDetector(
          onTap: () {
            if (tripId.isNotEmpty) {
              context.read<TripCubit>().cancelTrip(tripId);
            }
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10.sp),
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: AppColors.semiGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                S().cancel,
                style:
                    TextStyles.font18WhiteBold.copyWith(color: AppColors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    });
  }
}
