import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';

class RecentRide extends StatelessWidget {
  const RecentRide(
      {super.key, required this.trips, required this.onAddressSelected});
  final List<TripModel> trips;
  final Function(String address, LatLng latLng) onAddressSelected;

  @override
  Widget build(BuildContext context) {
    List<TripModel> uniqueTrips = [];
    Set<String> uniqueLatLngs = {};

    for (var trip in trips) {
      String latLngKey = '${trip.toLatLng.latitude},${trip.toLatLng.longitude}';
      if (!uniqueLatLngs.contains(latLngKey)) {
        uniqueTrips.add(trip);
        uniqueLatLngs.add(latLngKey);
      }
    }

    return ListView.builder(
      itemCount: uniqueTrips.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                safePrint(uniqueTrips[index].toLatLng);
                safePrint(uniqueTrips[index].to);
                onAddressSelected(
                    uniqueTrips[index].to, uniqueTrips[index].toLatLng);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.sp),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                        child: const Icon(
                          CupertinoIcons.clock,
                          color: AppColors.primary,
                        )),
                    horizontalSpacing(10.w),
                    Expanded(
                      child: Text(uniqueTrips[index].to),
                    ),
                  ],
                ),
              ),
            ),
            if (index != 1)
              Divider(
                color: Colors.grey.shade300,
              ),
          ],
        );
      },
    );
  }
}
