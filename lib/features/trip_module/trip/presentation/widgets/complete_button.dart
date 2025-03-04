import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../../../rating/presentation/pages/rating_bottom_sheet.dart';
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

          String destination = isPassenger
              ? RoutingEndpoints.passengerHome
              : RoutingEndpoints.driverHome;

          Future.delayed(Duration(milliseconds: 300), () {
            if (appNavKey.currentState != null) {
              safePrint("✅ Using appNavKey to navigate to: $destination");
              appNavKey.currentState!.pushReplacementNamed(destination).then((_) {
                safePrint("✅ Navigation successful!");
              }).catchError((error) {
                safePrint("🚨 Navigation error: $error");
              });
            } else {
              safePrint("⚠️ appNavKey is null. Using context.");
              Navigator.of(context).pushReplacementNamed(destination).then((_) {
                safePrint("✅ Context-based navigation successful!");
              }).catchError((error) {
                safePrint("🚨 Context navigation error: $error");
              });
            }
          });

          if (isPassenger) {
            FirebaseFirestore.instance.collection('trips').doc(tripId).get().then((tripDoc) {
              if (tripDoc.exists) {
                final tripData = tripDoc.data()!;
                final driverId = tripData['driverData']?['driverId'] ?? '';

                if (driverId.isNotEmpty) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: RatingBottomSheet(
                          tripId: tripId,
                          ratedUserId: driverId,
                          isDriver: false,
                        ),
                      ),
                    );
                  });
                } else {
                  safePrint("🚨 Driver ID missing in trip data!");
                }
              }
            }).catchError((error) {
              safePrint("🚨 Error fetching trip data: $error");
            });
          }
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
                  if (tripId.isNotEmpty) {
                    safePrint("🛠 Calling completeTrip() for tripId: $tripId");
                    context.read<TripCubit>().completeTrip(tripId,context,isPassenger);
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
