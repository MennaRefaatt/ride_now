import 'package:flutter/cupertino.dart';
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

class AddressSummarize extends StatefulWidget {
  const AddressSummarize({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    required this.tripCubit,
    required this.fromLatLng,
    required this.toLatLng,
  });
  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;
  final LatLng fromLatLng;
  final LatLng toLatLng;

  @override
  State<AddressSummarize> createState() => _AddressSummarizeState();
}

class _AddressSummarizeState extends State<AddressSummarize> {
  late String toAddress;
  late String tripId;

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
                        return AppButton(
                          text: "S().done",
                          textStyle: TextStyles.font14BlackRegular,
                          onPressed: () async {
                            try {
                              await widget.tripCubit
                                  .createTrip(
                                widget.fromAddress,
                                widget.fromLatLng,
                                toAddress,
                                widget.toLatLng,
                              )
                                  .then((_) {
                                tripId = SharedPref.getString(
                                        key: MySharedKeys.currentTripId) ??
                                    "";
                                if (tripId.isNotEmpty) {
                                  safePrint("Trip id: $tripId");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Trip id: $tripId")),
                                  );
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RoutingEndpoints.tripTracking,
                                    arguments: TripTrackingRouteArgs(
                                      tripTrackingArgs: TripTrackingArgs(
                                        fromAddress: widget.fromAddress,
                                        toAddress: toAddress,
                                        tripId: tripId,
                                        fromLatLng: widget.fromLatLng,
                                        toLatLng: widget.toLatLng,
                                        driverLatLng: widget.toLatLng,
                                        tripStatus: TripStatus.pending.name,
                                      ),
                                      isPassenger: true,
                                    ),
                                  );
                                } else {
                                  throw Exception(
                                      "Trip ID is missing after creation");
                                }
                              });
                            } catch (error) {
                              safePrint("Error creating trip: $error");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("Error creating trip: $error")),
                              );
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
            ),
          ],
        ),
      ),
    );
  }
}
