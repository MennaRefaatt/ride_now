import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class RecentRide extends StatelessWidget {
  const RecentRide({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.sp),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: const Icon(
                        CupertinoIcons.clock,
                        color: AppColors.primary,
                      )),
                  horizontalSpacing(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Home",
                            style: TextStyles.font18BlackRegular
                                .copyWith(fontWeight: FontWeight.bold)),
                        const Text("Cairo"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (index != 1)
            Divider(
              color: Colors.grey.shade300,
            )
          ]);
        });
  }
}
