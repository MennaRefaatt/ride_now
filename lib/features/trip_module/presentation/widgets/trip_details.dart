import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/trip_tracking.dart';
import '../manager/trip_cubit.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key, required this.args, required this.state});

  final TripTrackingArgs args;
  final AcceptTripLoaded state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TripTracking(args: args),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.r),
                topLeft: Radius.circular(40.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Destination: ${state.trip.to}',
                  style: TextStyles.font24BlackBold,
                ),
                // Add more trip details here
              ],
            ),
          ),
        ),
      ],
    );
  }
}
