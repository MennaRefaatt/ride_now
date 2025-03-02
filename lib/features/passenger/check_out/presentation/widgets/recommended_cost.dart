import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';

class RecommendedCost extends StatelessWidget {
  const RecommendedCost({super.key, required this.costText});
  final String costText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double cost = double.tryParse(costText) ?? 0.0;
    String formattedCost = (cost == cost.toInt())
        ? cost.toInt().toString()
        : cost.toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.all(15.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S().theCostOfTheOrderWillBe,
            style: theme.brightness == Brightness.dark
                ? TextStyles.font18WhiteRegular
                : TextStyles.font18BlackRegular,
          ),
          verticalSpacing(10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "EGP ",
                  style: TextStyles.font32BlueBold.copyWith(
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: formattedCost,
                  style: theme.brightness == Brightness.dark
                      ? TextStyles.font32BlueBold.copyWith(color: Colors.white)
                      : TextStyles.font32BlueBold.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            children: [
              Icon(Icons.account_balance_wallet),
              horizontalSpacing(10.w),
              Text(S().recommendedFare,
                  style: theme.brightness == Brightness.dark
                      ? TextStyles.font18WhiteRegular
                          .copyWith(fontWeight: FontWeight.bold)
                      : TextStyles.font18BlackRegular
                          .copyWith(fontWeight: FontWeight.bold)),
              Text(": $formattedCost EGP",
                  style: theme.brightness == Brightness.dark
                      ? TextStyles.font18WhiteRegular
                          .copyWith(fontWeight: FontWeight.bold)
                      : TextStyles.font18BlackRegular
                          .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
