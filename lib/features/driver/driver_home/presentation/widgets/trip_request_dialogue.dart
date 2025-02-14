import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/secure_storage/secure_storage.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/shared_pref_keys.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/helpers/enums/stripe_payment_status.dart';
import '../../../../../core/helpers/secure_storage/secure_keys.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/services/f_c_m_service/firebase_messaging_service.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/services/stripe/stripe_manager.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';
import '../../../../trip_module/trip/presentation/trip_tracking_args.dart';
import '../../../../trip_module/trip/presentation/trip_tracking_route_args.dart';

class TripRequestsDialogue extends StatefulWidget {
  const TripRequestsDialogue({super.key, required this.tripCubit});
  final TripCubit tripCubit;

  @override
  State<TripRequestsDialogue> createState() => _TripRequestsDialogueState();
}

class _TripRequestsDialogueState extends State<TripRequestsDialogue>
    with TickerProviderStateMixin {
  late List<AnimationController?> animationControllers;
  late List<Animation<Offset>?> slideAnimations;

  @override
  void initState() {
    super.initState();
    animationControllers = [];
    slideAnimations = [];
    widget.tripCubit.getTrips();
  }

  // void startSlideAnimation(int index) {
  //   if (animationControllers[index] != null) return;
  //
  //   final controller = AnimationController(
  //     duration: const Duration(seconds: 30),
  //     vsync: this,
  //   );
  //   animationControllers[index] = controller;
  //   slideAnimations[index] = Tween<Offset>(
  //     begin: Offset.zero,
  //     end: const Offset(-1.5, 0),
  //   ).animate(
  //     CurvedAnimation(parent: controller, curve: Curves.easeInOut),
  //   );
  //
  //   controller.forward();
  // }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller?.dispose();
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
        animationControllers =
            List<AnimationController?>.filled(trips.length, null);
        slideAnimations = List<Animation<Offset>?>.filled(trips.length, null);

        return ListView.builder(
          itemCount: trips.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            final trip = trips[index];
            final timeRemaining =
                trip.dateTime.difference(DateTime.now()).inSeconds;

            if (timeRemaining <= 0) {
              //startSlideAnimation(index);
            }

            return AnimatedBuilder(
              animation:
                  animationControllers[index] ?? AlwaysStoppedAnimation(0),
              builder: (context, child) {
                return SlideTransition(
                  position: slideAnimations[index] ??
                      AlwaysStoppedAnimation(Offset.zero),
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
                      value: timeRemaining > 0 ? timeRemaining / 30 : 0.0,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      trip.passengerData.passengerName,
                                      style: TextStyles.font24BlackBold,
                                    ),
                                  ),
                                  Text(
                                      "EGP ${trip.price.split('.')[0]} ${trip.paymentMethod}",
                                      style: TextStyles.font18primaryBold),
                                ],
                              ),
                              verticalSpacing(10.h),
                              Text(
                                trip.to,
                                style: TextStyles.font18BlackRegular,
                                overflow: TextOverflow.ellipsis,
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
                                        "Estimated time: ${trip.estimatedTime}",
                                        style: TextStyles.font18BlackRegular),
                                  ),
                                  Text(trip.distance,
                                      style: TextStyles.font18BlackRegular),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AppButton(
                                text: S().decline,
                                backgroundColor: Colors.grey.shade200,
                                onPressed: () {},
                                textStyle: TextStyles.font18WhiteBold.copyWith(
                                  color: AppColors.red,
                                ),
                                borderRadius: 10.r,
                                width: MediaQuery.of(context).size.width * 0.3,
                              ),
                              AppButton(
                                text: S().accept,
                                backgroundColor: AppColors.primary,
                                onPressed: () async {
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
                                  final driverToken = await SecureStorageService.readData(SecureKeys.deviceToken) ?? '';
                                  safePrint("driverId: $driverId");
                                  widget.tripCubit
                                      .acceptTrip(
                                          trip,
                                          DriverData(
                                              driverId: driverId,
                                              driverName: driverName,
                                              driverPhone: driverPhone,
                                              driverImage: driverImage,
                                              carModel: carModel,
                                              carColor: carColor,
                                              carNumber: carNumber,
                                              driverToken: driverToken,
                                              driverLocation: LatLng(
                                                driverLat,
                                                driverLong,
                                              )))
                                      .then((_) async {
                                    if (trip.tripId.isNotEmpty) {
                                      safePrint("Trip id: ${trip.tripId}");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Trip id: ${trip.tripId}")),
                                      );
                                      if (trip.passengerData.passengerToken
                                          .isNotEmpty) {
                                        await sendNotification(
                                          title: "رحلتك قيد التنفيذ!",
                                          body:
                                              "لقد قبل السائق $driverName رحلتك، استعد للانطلاق 🚗",
                                          token:
                                              trip.passengerData.passengerToken,
                                        );
                                      }
                                      Navigator.pushReplacementNamed(context,
                                          RoutingEndpoints.tripTracking,
                                          arguments: TripTrackingRouteArgs(
                                              tripTrackingArgs:
                                                  TripTrackingArgs(
                                                fromAddress: trip.from,
                                                toAddress: trip.to,
                                                tripId: trip.tripId,
                                                fromLatLng: trip.fromLatLng,
                                                toLatLng: trip.toLatLng,
                                                driverLatLng: LatLng(
                                                    driverLat, driverLong),
                                                tripStatus: trip.status,
                                              ),
                                              isPassenger: false));
                                    }
                                    final captureResult =
                                        await StripePaymentManager
                                            .capturePayment(trip.tripId);
                                    if (captureResult == 'Payment succeeded') {
                                      widget.tripCubit.updatePaymentStatus(
                                          StripePaymentStatus.succeeded.name);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: AppColors.primary,
                                        content: Text(
                                            'Payment Captured Successfully'),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: AppColors.red,
                                        content: Text(
                                            'Payment Capture Failed: $captureResult'),
                                      ));
                                    }
                                  });
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
