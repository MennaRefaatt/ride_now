import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/check_out/presentation/widgets/address_summarize.dart';
import 'package:ride_now/features/check_out/presentation/widgets/recommended_cost.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.semiGrey.withOpacity(0.2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: DefaultAppBar(
          text: "S().CheckOut",
          withDivider: false,
          backgroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          RecommendedCost(),
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
          AddressSummarize(),
        ],
      ),
    );
  }
}
