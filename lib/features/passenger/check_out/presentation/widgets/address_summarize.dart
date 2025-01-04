import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';

import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/presentation/manager/trip_cubit.dart';
import 'more_options.dart';

class AddressSummarize extends StatefulWidget {
  const AddressSummarize({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    required this.tripCubit,
  });
  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;

  @override
  State<AddressSummarize> createState() => _AddressSummarizeState();
}

class _AddressSummarizeState extends State<AddressSummarize> {
  late String toAddress;
  String? tripId;

  @override
  void initState() {
    super.initState();
    toAddress = widget.toAddress;
  }

  void _pickDestinationAddress(
    BuildContext context,
  ) {
    Navigator.pushNamed(context, RoutingEndpoints.maps).then((result) {
      if (result != null && result is String) {
        setState(() {
          toAddress = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(Icons.trip_origin),
                horizontalSpacing(10.w),
                Expanded(
                  child: Text(
                    widget.fromAddress,
                    style: TextStyles.font18BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.trip_origin),
                horizontalSpacing(10.w),
                Expanded(
                  child: Text(
                    toAddress,
                    style: TextStyles.font18BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _pickDestinationAddress(
                    context,
                  ),
                  icon: Icon(CupertinoIcons.add),
                ),
              ],
            ),
            Spacer(),
            Align(
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
                        if (state is CreateTripLoaded) {
                          tripId = state.trip.tripId;
                        }
                        return AppButton(
                          text: "S().done",
                          textStyle: TextStyles.font14BlackRegular,
                          onPressed: () async {
                            await widget.tripCubit
                                .createTrip(widget.fromAddress, toAddress)
                                .then((value) {
                              if (tripId != null && tripId!.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Trip created successfully: $tripId")),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  RoutingEndpoints.tripTracking,
                                  arguments: TripTrackingArgs(
                                    fromAddress: widget.fromAddress,
                                    toAddress: toAddress,
                                    tripId: tripId!,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error: Trip ID is missing")),
                                );
                              }
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Error creating trip: $error")),
                              );
                            });
                            safePrint("Order button pressed");
                          },
                          backgroundColor: AppColors.primary,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  MoreOptions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // void _onCreateTripOrGetExistingTrip(BuildContext context) async {
  //   try {
  //     final tripCubit = widget.tripCubit;
  //     final fromAddress = widget.fromAddress;
  //     final toAddress = widget.toAddress;
  //
  //     final tripDetails = await tripCubit.getTripDetails(tripId);
  //
  //     if (tripDetails != null) {
  //       // If a trip already exists, show it in the trip details screen
  //       Navigator.pushReplacementNamed(
  //         context,
  //         RoutingEndpoints.tripTracking,
  //         arguments: TripTrackingArgs(
  //           fromAddress: fromAddress,
  //           toAddress: toAddress,
  //           tripId: tripId,
  //         ),
  //       );
  //     } else {
  //       // Step 2: Create a new trip if no existing trip is found
  //       await tripCubit.createTrip(fromAddress, toAddress);
  //
  //       // Step 3: Navigate to the trip details screen after trip creation
  //       Navigator.pushReplacementNamed(
  //         context,
  //         RoutingEndpoints.tripTracking,
  //         arguments: TripTrackingArgs(
  //           fromAddress: fromAddress,
  //           toAddress: toAddress,
  //           tripId: tripId,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     // Handle any errors here
  //     safePrint("Error: $e");
  //     // You can show an error message if needed
  //   }
  // }
}
