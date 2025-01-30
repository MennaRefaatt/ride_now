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
        return Container(
          width: double.infinity,
          height: _childSize * MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: AppColors.semiGrey.withOpacity(0.8),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.r),
              topLeft: Radius.circular(40.r),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Waiting for driver",
                        style: TextStyles.font18WhiteRegular
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const CircleAvatar(),
                  ],
                ),
              ),
              Expanded(
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
                  child: SingleChildScrollView(
                    controller: scrollController, // Attach the scroll controller
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<TripCubit, TripState>(
                          builder: (context, state) {
                            if (state is GetTripDetailsLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
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
                              safePrint('Error loading trips: ${state.message}');
                              return Text('Error: ${state.message}');
                            }
                            return const SizedBox();
                          },
                        ),
                        SizedBox(height: 20.h), // Add spacing
                        CancelButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
