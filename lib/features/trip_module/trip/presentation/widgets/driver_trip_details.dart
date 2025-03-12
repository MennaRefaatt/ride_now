import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/trip_module/trip/presentation/widgets/your_current_trip.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../generated/l10n.dart';
import '../../data/models/trip_model.dart';
import 'contact_call.dart';

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
    final userName = tripModel.driverData.driverName.split(' ');
    final imageProvider = NetworkImage(tripModel.passengerData.passengerImage);
    final theme = Theme.of(context);
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
                      tripModel.passengerData.passengerName,
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
                        phone: tripModel.passengerData.passengerPhone,
                        callerName: tripModel.driverData.driverName,
                        receiverFCMToken:
                            tripModel.passengerData.passengerToken,
                        receiverProfilePicture:
                            tripModel.passengerData.passengerImage),
                    horizontalSpacing(10),
                    Text(
                      S().contactPassenger,
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
                verticalSpacing(20),
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
                isPassenger: isPassenger,
                tripId: tripModel.tripId,
                to: tripModel.to,
                from: tripModel.from),
          ],
        ),
      ],
    );
  }
}
