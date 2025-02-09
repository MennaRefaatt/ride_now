import 'package:ride_now/features/trip_module/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/contact_call.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/your_current_trip.dart';
import '../../../../core/helpers/spacing.dart';

class DriverTripDetails extends StatelessWidget {
  const DriverTripDetails({
    super.key,
    required this.tripModel,
    required this.isPassenger,
  });
  final TripModel tripModel;
  final bool isPassenger;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                    ),
                    horizontalSpacing(10.w),
                    Text(
                      tripModel.passengerData.passengerName,
                      style: TextStyles.font18BlackRegular,
                    ),
                  ],
                ),
                horizontalSpacing(20.w),
                Column(
                  children: [
                    ContactCall(
                      phone: tripModel.passengerData.passengerPhone,
                      callerName: tripModel.driverData.driverName,
                      receiverFCMToken: tripModel.passengerData.passengerToken,
                    ),
                    horizontalSpacing(10.w),
                    Text(
                      "Contact Passenger",
                      style: TextStyles.font18BlackRegular,
                    ),
                  ],
                ),
              ],
            ),
            verticalSpacing(10.h),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment",
                  style: TextStyles.font24BlackBold,
                ),
                verticalSpacing(20.h),
                Text(
                  "EGP ${tripModel.price} ${tripModel.paymentMethod}",
                  style: TextStyles.font18BlackRegular,
                ),
              ],
            ),
            verticalSpacing(10.h),
            Divider(),
            verticalSpacing(10.h),
            YourCurrentTrip(
                isPassenger: isPassenger,
                to: tripModel.to, from: tripModel.from),
          ],
        ),
      ],
    );
  }
}
