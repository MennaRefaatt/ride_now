import 'package:ride_now/features/trip_module/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_image.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/contact_call.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/your_current_trip.dart';
import '../../../../core/helpers/spacing.dart';

class PassengerTripDetails extends StatelessWidget {
  const PassengerTripDetails({super.key, required this.tripModel});
  final TripModel tripModel;
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
              children: [
                Expanded(
                  child: Text(
                    "${tripModel.driverData.carColor} ${tripModel.driverData.carModel}",
                    style: TextStyles.font24BlackBold,
                  ),
                ),
                Column(
                  children: [
                    AppImageAsset(
                      path: "icons/app_icon.png",
                      height: 50.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      " ${tripModel.driverData.carNumber}",
                      style: TextStyles.font24BlackBold,
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            verticalSpacing(10.h),
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
                      tripModel.driverData.driverName,
                      style: TextStyles.font18BlackRegular,
                    ),
                  ],
                ),
                horizontalSpacing(20.w),
                Column(
                  children: [
                    ContactCall(
                      phone: tripModel.driverData.driverPhone,
                      callerName: tripModel.passengerData.passengerName,
                      receiverFCMToken: tripModel.driverData.driverToken,
                    ),
                    horizontalSpacing(10.w),
                    Text(
                      "Contact Driver",
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
            YourCurrentTrip(to: tripModel.to, from: tripModel.from),
          ],
        ),
      ],
    );
  }
}
