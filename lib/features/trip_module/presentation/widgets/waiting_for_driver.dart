import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/cancel_button.dart';
import '../../../../../core/theming/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../manager/trip_cubit.dart';

class WaitingForDriver extends StatefulWidget {
  const WaitingForDriver({super.key});

  @override
  State<WaitingForDriver> createState() => _WaitingForDriverState();
}

class _WaitingForDriverState extends State<WaitingForDriver>
    with TickerProviderStateMixin {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _childSize = 0.4;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: _childSize,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3 * _childSize,
              width: double.infinity,
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                color: AppColors.semiGrey.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                  topLeft: Radius.circular(40.r),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Waiting for driver",
                        style: TextStyles.font18WhiteRegular
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                      CircleAvatar()
                    ],
                  ),
                  verticalSpacing(20.h),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    double newHeight = _childSize -
                        details.primaryDelta! /
                            MediaQuery.of(context).size.height;
                    if (newHeight > 0.2 && newHeight < 0.9) {
                      setState(() {
                        _childSize = newHeight;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.8 *
                        _childSize, // Adjusted size
                    padding: EdgeInsets.all(15.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.r),
                        topLeft: Radius.circular(40.r),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder<TripCubit, TripState>(
                              builder: (context, state) {
                                if (state is GetTripDetailsLoading) {
                                  return const CircularProgressIndicator(
                                    color: AppColors.primary,
                                  );
                                } else if (state is GetTripDetailsLoaded) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Destination: ${state.trip.to}',
                                        style: TextStyles.font24BlackBold,
                                      ),
                                      Text(
                                        'From: ${state.trip.from}',
                                        style: TextStyles.font18BlackRegular,
                                      ),
                                      Text(
                                        'Price: ${state.trip.price} ${state.trip.paymentMethod}',
                                        style: TextStyles.font18BlackRegular,
                                      ),
                                    ],
                                  );
                                } else if (state is GetTripDetailsError) {
                                  safePrint(
                                      'Error loading trips: ${state.message}');
                                  return Text('Error: ${state.message}');
                                }
                                return const SizedBox();
                              },
                            ),
                            CancelButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
