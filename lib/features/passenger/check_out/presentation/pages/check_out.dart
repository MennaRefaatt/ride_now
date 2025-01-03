import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import 'package:ride_now/features/trip_module/presentation/manager/trip_cubit.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../widgets/address_summarize.dart';
import '../widgets/recommended_cost.dart';

class CheckOut extends StatelessWidget {
  CheckOut({
    super.key,
    required this.args,
  });
  final CheckOutArgs args;
  final tripCubit = TripCubit(
      acceptTripUseCase: sl(), getTripsUseCase: sl(), createTripUseCase: sl(),getTripDetailsUseCase: sl(),cancelTripUseCase: sl());
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => tripCubit,
      child: Scaffold(
        backgroundColor: AppColors.semiGrey.withOpacity(0.2),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(
            text: "S().CheckOut",
            withDivider: false,
            backgroundColor: Colors.white,
            leading: true,
            onPressed: () => Navigator.pop(context, args.toAddress),
          ),
        ),
        body: Column(
          children: [
            RecommendedCost(
              costText: tripCubit.cost.toString(),
            ),
            verticalSpacing(10.h),
            Container(
              padding: EdgeInsets.all(15.sp),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.wallet),
                  horizontalSpacing(10.w),
                  Expanded(
                      child: Text("Cash",
                          style: TextStyles.font18BlackRegular
                              .copyWith(fontWeight: FontWeight.bold))),
                  Icon(CupertinoIcons.right_chevron),
                ],
              ),
            ),
            verticalSpacing(10.h),
            AddressSummarize(
              fromAddress: args.fromAddress,
              toAddress: args.toAddress,
              tripCubit: tripCubit,
            ),
          ],
        ),
      ),
    );
  }
}
