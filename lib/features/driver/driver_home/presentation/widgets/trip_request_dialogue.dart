import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/trip_module/presentation/manager/trip_cubit.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';

class TripRequestsDialogue extends StatefulWidget {
  const TripRequestsDialogue({super.key});

  @override
  State<TripRequestsDialogue> createState() => _TripRequestsDialogueState();
}

class _TripRequestsDialogueState extends State<TripRequestsDialogue>
    with TickerProviderStateMixin {
  late List<double> progressValues;
  late List<Timer> timers;
  late List<AnimationController> animationControllers;
  late List<Animation<Offset>> slideAnimations;

  @override
  void initState() {
    super.initState();
    progressValues =
        List.generate(5, (index) => 1.0); // Initialize progress to full
    timers = List.generate(5, (index) => _createTimer(index));
    animationControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    slideAnimations = animationControllers
        .map((controller) =>
            Tween<Offset>(begin: Offset.zero, end: const Offset(-1.5, 0))
                .animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            )))
        .toList();
  }

  Timer _createTimer(int index) {
    return Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (progressValues[index] > 0) {
          progressValues[index] -= 0.01; // Decrement progress
        } else {
          timer.cancel(); // Stop the timer when progress reaches 0
          animationControllers[index].forward(); // Trigger animation
        }
      });
    });
  }

  @override
  void dispose() {
    for (var timer in timers) {
      timer.cancel();
    }
    for (var controller in animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripCubit, TripState>(
      builder: (context, state) {
        if (state is TripsLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (state is TripsLoaded) {
        return ListView.builder(
          itemCount: state.trips.length,
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
                      value: progressValues[index],
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
                                  // CircleAvatar(
                                  //   radius: 30.r,
                                  //   backgroundImage: NetworkImage(
                                  //       "https://graph.facebook.com/3465091310463908/picture"),
                                  // ),
                                  // horizontalSpacing(10.w),
                                  Expanded(
                                    child: Text(
                                      state.trips[index].passengerName,
                                      style: TextStyles.font24BlackBold,
                                    ),
                                  ),
                                  Text(state.trips[index].price.toString(),
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
                                    child: Text(state.trips[index].dateTime.toString(),
                                        style: TextStyles.font18BlackRegular),
                                  ),
                                  Text(state.trips[index].distance.toString(),
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
                                onPressed: () {},
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
        }

        return Container();
      },
    );
  }
}
