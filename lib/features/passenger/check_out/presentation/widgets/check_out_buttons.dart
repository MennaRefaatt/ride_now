import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/presentation/manager/trip_cubit.dart';
import '../../../../trip_module/presentation/trip_tracking_route_args.dart';
import 'more_options.dart';

class CheckOutButtons extends StatelessWidget {
  CheckOutButtons(
      {super.key,
      required this.tripCubit,
      required this.fromAddress,
      required this.toAddress,
      required this.fromLatLng,
      required this.paymentMethod,
      required this.toLatLng});

  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  late String tripId;
  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if (state is CreateTripLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                return AppButton(
                  text: "S().done",
                  textStyle: TextStyles.font18BlackBold,
                  onPressed: () async {
                    try {
                      await tripCubit
                          .createTrip(
                        fromAddress,
                        fromLatLng,
                        toAddress,
                        toLatLng,
                        paymentMethod,
                      )
                          .then((_) {
                        tripId = SharedPref.getString(
                                key: MySharedKeys.currentTripId) ??
                            "";
                        if (tripId.isNotEmpty) {
                          safePrint("Trip id: $tripId");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.primary,
                                content: Text("Trip id: $tripId"),
                              ),
                            );
                          }
                          Navigator.pushReplacementNamed(
                            context,
                            RoutingEndpoints.tripTracking,
                            arguments: TripTrackingRouteArgs(
                              tripTrackingArgs: TripTrackingArgs(
                                fromAddress: fromAddress,
                                toAddress: toAddress,
                                tripId: tripId,
                                fromLatLng: fromLatLng,
                                toLatLng: toLatLng,
                                driverLatLng: LatLng(0, 0),
                                tripStatus: TripStatus.pending.name,
                              ),
                              isPassenger: true,
                            ),
                          );
                        } else {
                          throw Exception("Trip ID is missing after creation");
                        }
                      });
                    } catch (error) {
                      safePrint("Error creating trip: $error");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: AppColors.red,
                              content: Text(
                                "Error creating trip: $error",
                              )),
                        );
                      }
                      return;
                    }
                    safePrint("Order button pressed");
                  },
                  backgroundColor: AppColors.primary,
                  width: double.infinity,
                );
              },
            ),
          ),
          horizontalSpacing(10.w),
          MoreOptions(),
        ],
      ),
    );
  }
}
