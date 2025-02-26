import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/driver/driver_home/presentation/widgets/trip_actions.dart';
import 'package:ride_now/features/driver/driver_home/presentation/widgets/trip_details.dart';
import 'package:ride_now/features/driver/driver_home/presentation/widgets/trip_progress_bar.dart';

import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';

class TripRequestCard extends StatelessWidget {
  final TripModel trip;
  final TripCubit tripCubit;
  final VoidCallback onTimerEnd;

  const TripRequestCard({
    super.key,
    required this.trip,
    required this.tripCubit,
    required this.onTimerEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      color: Colors.white,
      elevation: 5,
      child: Column(
        children: [
          TripProgressBar(onTimerEnd: onTimerEnd),
          DTripDetails(trip: trip),
          TripActions(trip: trip, tripCubit: tripCubit),
        ],
      ),
    );
  }
}
