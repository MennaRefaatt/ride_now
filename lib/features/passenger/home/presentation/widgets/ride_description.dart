import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../../core/components/app_network_image.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';

class RideDescription extends StatelessWidget {
  const RideDescription({
    super.key,
    required this.image,
    required this.text,
    required this.description,
  });
  final String image;
  final String text;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: theme.brightness == Brightness.dark
                    ? TextStyles.font34WhiteExtraBold
                    : TextStyles.font34BlackExtraBold,
              ),
              AppNetworkImage(
                borderRadius: BorderRadius.circular(10.r),
                imageUrl: image,
                width: 150.w,
                height: 100.h,
              ),
            ],
          ),
          verticalSpacing(20),
          Text(
            description,
            style: theme.brightness == Brightness.dark
                ? TextStyles.font18WhiteRegular
                : TextStyles.font18BlackRegular,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
          verticalSpacing(20),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.semiGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                  child: Text(S().ok,
                      style: theme.brightness == Brightness.dark
                          ? TextStyles.font18WhiteBold
                          : TextStyles.font18BlackBold)),
            ),
          )
        ],
      ),
    );
  }
}
