import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/cancel_button.dart';
import '../../../../../core/theming/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/trip_tracking.dart';
import '../manager/trip_cubit.dart';

class WaitingForDriver extends StatelessWidget {
  const WaitingForDriver({super.key, required this.args});
  final TripTrackingArgs args;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TripTracking(
          args: args,
        ),
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
                            'Price: ${state.trip.price}',
                            style: TextStyles.font18BlackRegular,
                          )
                        ],
                      );
                    } else if (state is GetTripDetailsError) {
                      safePrint('Error loading trips: ${state.message}');
                      return Text('Error: ${state.message}');
                    }
                    return const SizedBox();
                  },
                ),
                CancelButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
