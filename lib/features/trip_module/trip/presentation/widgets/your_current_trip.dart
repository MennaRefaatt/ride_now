import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import '../../../../../core/helpers/spacing.dart';
import 'complete_button.dart';

class YourCurrentTrip extends StatelessWidget {
  final String from;
  final String to;
  final bool isPassenger;
  final String tripId;
  const YourCurrentTrip(
      {super.key,
      required this.from,
      required this.to,
      required this.isPassenger,
      required this.tripId});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Current Trip",
          style: TextStyles.font24BlackBold,
        ),
        verticalSpacing(20),
        Row(
          children: [
            Icon(
              Icons.trip_origin,
              color: AppColors.red,
            ),
            horizontalSpacing(10),
            Expanded(
              child: Text(
                from,
                style: TextStyles.font18BlackRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(10),
        Row(
          children: [
            Icon(
              Icons.trip_origin,
              color: AppColors.primary,
            ),
            horizontalSpacing(10),
            Expanded(
              child: Text(
                to,
                style: TextStyles.font18BlackRegular.copyWith(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(20),
        Visibility(
            visible: isPassenger == false,
            child: CompleteButton(tripId: tripId, isPassenger: isPassenger)),
      ],
    );
  }
}
