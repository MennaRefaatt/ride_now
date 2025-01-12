import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/cancel_button.dart';
import '../../../../../core/theming/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../manager/trip_cubit.dart';

class WaitingForDriver extends StatefulWidget {
  const WaitingForDriver({
    super.key,
  });

  @override
  State<WaitingForDriver> createState() => _WaitingForDriverState();
}

class _WaitingForDriverState extends State<WaitingForDriver> {
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
          );
        });
  }
}
