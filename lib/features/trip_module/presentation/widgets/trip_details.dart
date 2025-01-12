import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_image.dart';
import 'package:ride_now/features/trip_module/data/models/trip_model.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/contact_call.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/your_current_trip.dart';
import '../../../../core/helpers/spacing.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key, required this.tripModel});

  final TripModel tripModel;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _childSize = 0.3;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: _childSize,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              double newHeight = _childSize -
                  details.primaryDelta! / MediaQuery.of(context).size.height;
              if (newHeight > 0.2 && newHeight < 0.8) {
                setState(() {
                  _childSize = newHeight;
                });
              }
            },
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
              child: ListView(
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
                              "${widget.tripModel.driverData.carColor} ${widget.tripModel.driverData.carModel}",
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
                                " ${widget.tripModel.driverData.carNumber}",
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
                                widget.tripModel.driverData.driverName,
                                style: TextStyles.font18BlackRegular,
                              ),
                            ],
                          ),
                          horizontalSpacing(20.w),
                          Column(
                            children: [
                              ContactCall(
                                driverPhone:
                                    widget.tripModel.driverData.driverPhone,
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
                            "EGP ${widget.tripModel.price} Cash",
                            style: TextStyles.font18BlackRegular,
                          ),
                        ],
                      ),
                      verticalSpacing(10.h),
                      Divider(),
                      verticalSpacing(10.h),
                      YourCurrentTrip(
                          to: widget.tripModel.to, from: widget.tripModel.from),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
