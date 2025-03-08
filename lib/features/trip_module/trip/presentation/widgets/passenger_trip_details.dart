import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_image.dart';
import 'package:ride_now/features/trip_module/trip/presentation/widgets/your_current_trip.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../generated/l10n.dart';
import '../../data/models/trip_model.dart';
import 'contact_call.dart';

class PassengerTripDetails extends StatelessWidget {
  const PassengerTripDetails(
      {super.key, required this.tripModel, required this.isPassenger});
  final TripModel tripModel;
  final bool isPassenger;
  @override
  Widget build(BuildContext context) {
    final userName = tripModel.passengerData.passengerName.split(' ');
    final imageProvider = NetworkImage(tripModel.driverData.driverImage);
    final theme = Theme.of(context);

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
                    style: theme.brightness == Brightness.dark
                        ? TextStyles.font24WhiteBold
                        : TextStyles.font24BlackBold,
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
                      style: theme.brightness == Brightness.dark
                          ? TextStyles.font24WhiteBold
                          : TextStyles.font24BlackBold,
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            verticalSpacing(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? Text(
                              userName.isNotEmpty ? userName[0] : '',
                              style: TextStyles.font18BlackRegular,
                            )
                          : null,
                    ),
                    horizontalSpacing(10),
                    Text(
                      tripModel.driverData.driverName,
                      style: theme.brightness == Brightness.dark
                          ? TextStyles.font18WhiteRegular
                          : TextStyles.font18BlackRegular,
                    ),
                  ],
                ),
                horizontalSpacing(20),
                Column(
                  children: [
                    ContactCall(
                      receiverProfilePicture: tripModel.driverData.driverImage,
                      phone: tripModel.driverData.driverPhone,
                      callerName: tripModel.passengerData.passengerName,
                      receiverFCMToken: tripModel.driverData.driverToken,
                    ),
                    horizontalSpacing(10),
                    Text(
                      S().contactDriver,
                      style: theme.brightness == Brightness.dark
                          ? TextStyles.font18WhiteRegular
                          : TextStyles.font18BlackRegular,
                    ),
                  ],
                ),
              ],
            ),
            verticalSpacing(10),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S().payment,
                  style: theme.brightness == Brightness.dark
                      ? TextStyles.font24WhiteBold
                      : TextStyles.font24BlackBold,
                ),
                verticalSpacing(20.h),
                Text(
                  "EGP ${tripModel.price} ${tripModel.paymentMethod}",
                  style: theme.brightness == Brightness.dark
                      ? TextStyles.font18WhiteRegular
                      : TextStyles.font18BlackRegular,
                ),
              ],
            ),
            verticalSpacing(10),
            Divider(),
            verticalSpacing(10),
            YourCurrentTrip(
                tripId: tripModel.tripId,
                isPassenger: isPassenger,
                to: tripModel.to,
                from: tripModel.from),
          ],
        ),
      ],
    );
  }
}
