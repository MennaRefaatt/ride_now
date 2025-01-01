import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';

import '../../../../../core/helpers/safe_print.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/presentation/manager/trip_cubit.dart';
import 'more_options.dart';

class AddressSummarize extends StatelessWidget {
  const AddressSummarize({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    required this.tripCubit,
  });
  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(Icons.trip_origin),
                horizontalSpacing(10.w),
                Expanded(
                  child: Text(
                    fromAddress,
                    style: TextStyles.font18BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.trip_origin),
                horizontalSpacing(10.w),
                Expanded(
                  child: Text(
                    toAddress,
                    style: TextStyles.font18BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.add),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<TripCubit, TripState>(
                      builder: (context, state) {
                        if (state is CreateTripLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        return AppButton(
                          text: "S().done",
                          textStyle: TextStyles.font14BlackRegular,
                          onPressed: () async {
                            await tripCubit.createTrip(
                              fromAddress,
                              toAddress,
                            );
                            safePrint("Order button pressed");
                          },
                          backgroundColor: AppColors.primary,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  MoreOptions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
