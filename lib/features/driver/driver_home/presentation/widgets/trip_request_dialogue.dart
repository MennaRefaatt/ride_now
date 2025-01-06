import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/trip_module/data/models/trip_model.dart';
import 'package:ride_now/features/trip_module/presentation/manager/trip_cubit.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';

class TripRequestsDialogue extends StatefulWidget {
  const TripRequestsDialogue({super.key, required this.tripCubit});
  final TripCubit tripCubit;

  @override
  State<TripRequestsDialogue> createState() => _TripRequestsDialogueState();
}

class _TripRequestsDialogueState extends State<TripRequestsDialogue>
    with TickerProviderStateMixin {
  late List<AnimationController> animationControllers;
  late List<Animation<Offset>> slideAnimations;

  @override
  void initState() {
    super.initState();
    animationControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(seconds: 30),
        vsync: this,
      ),
    );
    slideAnimations = animationControllers
        .map((controller) => Tween<Offset>(
                begin: Offset.zero, end: const Offset(-1.5, 0))
            .animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut)))
        .toList();
    for (var controller in animationControllers) {
      controller.forward();
    }
    widget.tripCubit.getTrips();
  }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripModel>>(
      stream: widget.tripCubit.listenToTrips(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasError) {
          safePrint(snapshot.error);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No trip requests available'),
          );
        }

        final trips = snapshot.data!;

        return ListView.builder(
          itemCount: trips.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return AnimatedBuilder(
              animation: animationControllers[index],
              builder: (context, child) {
                return SlideTransition(
                  position: slideAnimations[index],
                  child: child,
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                color: Colors.white,
                elevation: 5,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: 1.0 - animationControllers[index].value,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.primary,
                      minHeight: 6.h,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      trips[index].passengerData.passengerName,
                                      style: TextStyles.font24BlackBold,
                                    ),
                                  ),
                                  Text(trips[index].price.toString(),
                                      style: TextStyles.font18primaryBold),
                                ],
                              ),
                              verticalSpacing(20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.timer,
                                    color: AppColors.primary,
                                  ),
                                  horizontalSpacing(5.w),
                                  Expanded(
                                    child: Text(
                                        trips[index].dateTime.toString(),
                                        style: TextStyles.font18BlackRegular),
                                  ),
                                  Text(trips[index].distance.toString(),
                                      style: TextStyles.font18BlackRegular),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AppButton(
                                text: "Reject",
                                backgroundColor: Colors.grey.shade200,
                                onPressed: () {},
                                textStyle: TextStyles.font18WhiteBold.copyWith(
                                  color: AppColors.red,
                                ),
                                borderRadius: 10.r,
                                width: MediaQuery.of(context).size.width * 0.3,
                              ),
                              AppButton(
                                text: "Accept",
                                backgroundColor: AppColors.primary,
                                onPressed: () {
                                  final driverId = SharedPref.getString(
                                      key: MySharedKeys.driverId)!;
                                  final driverName = SharedPref.getString(
                                      key: MySharedKeys.driverName)!;
                                  final driverPhone = SharedPref.getString(
                                      key: MySharedKeys.driverPhone)!;
                                  final driverImage = SharedPref.getString(
                                      key: MySharedKeys.driverPicture)!;
                                  final driverLat = SharedPref.getDouble(
                                      key: MySharedKeys.driverLatitude)!;
                                  final driverLong = SharedPref.getDouble(
                                      key: MySharedKeys.driverLongitude)!;
                                  final carModel = SharedPref.getString(
                                      key: MySharedKeys.carModel)!;
                                  final carNumber = SharedPref.getString(
                                      key: MySharedKeys.carNumber)!;
                                  final carColor = SharedPref.getString(
                                      key: MySharedKeys.carColor)!;
                                  safePrint("driverId: $driverId");
                                  widget.tripCubit.acceptTrip(
                                      trips[index],
                                      DriverData(
                                          driverId: driverId,
                                          driverName: driverName,
                                          driverPhone: driverPhone,
                                          driverImage: driverImage,
                                          carModel: carModel,
                                          carColor: carColor,
                                          carNumber: carNumber,
                                          driverLocation: DriverLocation(
                                            latitude: driverLat,
                                            longitude: driverLong,
                                          ),
                                      ));
                                },
                                textStyle: TextStyles.font18BlackRegular,
                                borderRadius: 10.r,
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
