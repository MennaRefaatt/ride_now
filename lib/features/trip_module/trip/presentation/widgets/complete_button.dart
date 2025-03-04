import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/components/app_entry_point.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../generated/l10n.dart';
import '../manager/trip_cubit.dart';
class CompleteButton extends StatelessWidget {
  const CompleteButton({
    super.key,
    required this.isPassenger,
    required this.tripId,
  });

  final bool isPassenger;
  final String tripId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripCubit, TripState>(
      listener: (context, state) {
        safePrint("🚀 BlocListener received state: $state");

        if (state is CompleteTripLoaded) {
          safePrint("✅ BlocListener detected CompleteTripLoaded");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip completed successfully!')),
          );
        } else if (state is CompleteTripError) {
          safePrint("🚨 Error: ${state.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error completing trip: ${state.message}')),
          );
        }
      },
      child: BlocBuilder<TripCubit, TripState>(
        builder: (context, state) {
          return Visibility(
            visible: tripId.isNotEmpty,
            child: Center(
              child: AppButton(
                onPressed: () {
                  if (tripId.isNotEmpty&&tripId != "") {
                    safePrint("🛠 Calling completeTrip() for tripId: $tripId");
                    context.read<TripCubit>().completeTrip(tripId,context,isPassenger).then((value) {
                      String destination = isPassenger
                          ? RoutingEndpoints.passengerHome
                          : RoutingEndpoints.driverHome;
                      Future.delayed(Duration(milliseconds: 500), () {
                        safePrint("🚀 Navigating to: $destination");
                        if (appNavKey.currentState != null) {
                          appNavKey.currentState!.pushReplacementNamed(destination);
                          safePrint("✅ Navigation successful!");
                        } else if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed(destination);
                        }
                      });
                    });
                  }
                },
                text: S().tripCompleted,
                textStyle: TextStyles.font18WhiteBold,
                backgroundColor: AppColors.primary,
                borderRadius: 10.r,
              ),
            ),
          );
        },
      ),
    );
  }
}
