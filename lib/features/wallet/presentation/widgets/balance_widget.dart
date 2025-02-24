
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key, required this.balance, required this.lastUpdatedText});
final double balance;
final String lastUpdatedText;
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(10.sp),
      padding:
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.semiGrey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundColor:
            AppColors.semiGrey.withValues(alpha: 0.2),
            radius: 30.r,
            child: Icon(Icons.wallet, color: AppColors.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S().yourBalance,
                    style: TextStyles.font18BlackBold),
                Text(
                  balance.toStringAsFixed(2).padLeft(2, '0'),
                  style: TextStyles.font24BlackBold,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S().lastUpdated,
                    style: TextStyles.font18BlackBold),
                Text(
                  lastUpdatedText,
                  style: TextStyles.font18BlackBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
