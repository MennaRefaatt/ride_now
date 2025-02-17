import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';

class DTripDetails extends StatelessWidget {
  final TripModel trip;

  const DTripDetails({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(trip.passengerData.passengerName, style: TextStyles.font24BlackBold)),
              Text("EGP ${trip.price.split('.')[0]} ${trip.paymentMethod}", style: TextStyles.font18primaryBold),
            ],
          ),
          verticalSpacing(10.h),
          Text(trip.to, style: TextStyles.font18BlackRegular, overflow: TextOverflow.ellipsis),
          verticalSpacing(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.timer, color: AppColors.primary),
              horizontalSpacing(5.w),
              Expanded(child: Text("${S().estimatedTime}: ${trip.estimatedTime}", style: TextStyles.font18BlackRegular)),
              Text(trip.distance, style: TextStyles.font18BlackRegular),
            ],
          ),
        ],
      ),
    );
  }
}
