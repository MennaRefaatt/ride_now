import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/components/app_entry_point.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../generated/l10n.dart';
import '../manager/trip_cubit.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton(
      {super.key, required this.isPassenger, required this.tripId});
  final bool isPassenger;
  final String tripId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(listener: (context, state) {
      if (state is CompleteTripLoaded) {
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
      } else if (state is CompleteTripError) {
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
        child: Center(
          child: AppButton(
              onPressed: () {
                if (tripId.isNotEmpty) {
                  context.read<TripCubit>().completeTrip(tripId);
                }
              },
              text: S().tripCompleted,
              textStyle:
                  TextStyles.font18WhiteBold,
              backgroundColor: AppColors.primary,
              borderRadius: 10.r),
        ),
      );
    });
  }
}
