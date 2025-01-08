import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_image.dart';
import 'package:ride_now/features/trip_module/data/models/trip_model.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/trip_tracking.dart';
import '../../../../core/helpers/spacing.dart';
import 'cancel_button.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key, required this.args, required this.tripModel});

  final TripTrackingArgs args;
  final TripModel tripModel;

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
                          //backgroundImage: NetworkImage(tripModel.driverData.driverImage),
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
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.primary,
                          child: Icon(CupertinoIcons.phone),
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
                      "EGP ${tripModel.price} Cash",
                      style: TextStyles.font18BlackRegular,
                    ),
                  ],
                ),
                verticalSpacing(10.h),
                Divider(),
                verticalSpacing(10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Durrent Trip",
                      style: TextStyles.font24BlackBold,
                    ),
                    verticalSpacing(20.h),
                    Row(
                      children: [
                        Icon(
                          Icons.trip_origin,
                          color: AppColors.red,
                        ),
                        horizontalSpacing(10.w),
                        Expanded(
                          child: Text(
                            tripModel.from,
                            style: TextStyles.font18BlackRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(10.h),
                    Row(
                      children: [
                        Icon(
                          Icons.trip_origin,
                          color: AppColors.primary,
                        ),
                        horizontalSpacing(10.w),
                        Expanded(
                          child: Text(
                            tripModel.to,
                            style: TextStyles.font18BlackRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(20.h),
                    CancelButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
