import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../../core/services/f_c_m_service/firebase_messaging_service.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';
import '../../../../trip_module/trip/presentation/trip_tracking_args.dart';
import '../../../../trip_module/trip/presentation/trip_tracking_route_args.dart';
import 'more_options.dart';

class CheckOutButtons extends StatefulWidget {
  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final String paymentMethod;
  final double cost;
  const CheckOutButtons({
    super.key,
    required this.tripCubit,
    required this.fromAddress,
    required this.toAddress,
    required this.fromLatLng,
    required this.toLatLng,
    required this.paymentMethod,
    required this.cost,
  });

  @override
  State<CheckOutButtons> createState() => _CheckOutButtonsState();
}

class _CheckOutButtonsState extends State<CheckOutButtons> {
  bool moreThan4Passengers = false;
  final TextEditingController commentController = TextEditingController();
  late String tripId;

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
                  text: S().done,
                  textStyle: TextStyles.font18BlackBold,
                  onPressed: () async {
                    try {
                      safePrint(widget.toAddress);
                      await widget.tripCubit
                          .createTrip(
                        widget.fromAddress,
                        widget.fromLatLng,
                        widget.toAddress,
                        widget.toLatLng,
                        widget.paymentMethod,
                        moreThan4Passengers,
                        commentController.text,
                        widget.cost,
                      )
                          .then((_) async {
                        await Future.delayed(Duration(
                            milliseconds: 500)); // Allow some time for storage

                        tripId = SharedPref.getString(
                                key: MySharedKeys.currentTripId) ??
                            "";
                        if (tripId.isNotEmpty) {
                          safePrint("Trip id: $tripId");
                          if (!mounted) {
                            return; // Ensure widget is mounted before UI updates
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primary,
                              content: Text("Trip id: $tripId"),
                            ),
                          );
                          onTripCreated();
                          Navigator.pushReplacementNamed(
                            context,
                            RoutingEndpoints.tripTracking,
                            arguments: TripTrackingRouteArgs(
                              tripTrackingArgs: TripTrackingArgs(
                                fromAddress: widget.fromAddress,
                                toAddress: widget.toAddress,
                                tripId: tripId,
                                fromLatLng: widget.fromLatLng,
                                toLatLng: widget.toLatLng,
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
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.red,
                          content: Text("Error creating trip: $error"),
                        ),
                      );
                    }
                  },
                  backgroundColor: AppColors.primary,
                  width: double.infinity,
                );
              },
            ),
          ),
          horizontalSpacing(10.w),
          MoreOptions(
            onApply: (bool morePassengers, String comment) {
              setState(() {
                moreThan4Passengers = morePassengers;
                commentController.text = comment;
              });
            },
            commentController: commentController,
          ),
        ],
      ),
    );
  }
  void onTripCreated() async {
    String title = "New Trip Available!";
    String body = "A new trip has been created. Check it out!";
    String topic = "drivers";

    await sendNotification(title: title, body: body, topic: topic);
  }

}
