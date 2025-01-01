import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';

import '../../../../../core/theming/styles.dart';
class RecommendedCost extends StatelessWidget {
  const RecommendedCost({super.key, required this.costText});
final String costText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "S().The cost of the order will be",
            style: TextStyles.font18BlackRegular,
          ),
          verticalSpacing(10.h),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "EGP ",
              style: TextStyles.font32BlueBold.copyWith(
                color: Colors.grey,
              ),
            ),
            TextSpan(
              text: costText,
              style: TextStyles.font32BlueBold.copyWith(color: Colors.black),
            ),
          ])),
          Divider(),
          Row(
            children: [
              Icon(Icons.account_balance_wallet),
              horizontalSpacing(10.w),
              Text("Recommended fare:",
                  style: TextStyles.font18BlackRegular
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(" EGP 100",
                  style: TextStyles.font18BlackRegular
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
