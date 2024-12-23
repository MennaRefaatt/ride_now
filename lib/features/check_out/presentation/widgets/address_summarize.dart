import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/check_out/presentation/widgets/more_options.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';

class AddressSummarize extends StatelessWidget {
  const AddressSummarize({super.key});

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
                Text("Address",
                    style: TextStyles.font18BlackRegular
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.trip_origin),
                horizontalSpacing(10.w),
                Expanded(
                    child: Text("Address",
                        style: TextStyles.font18BlackRegular
                            .copyWith(fontWeight: FontWeight.bold))),
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.add)),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                        text: S().done,
                        height: MediaQuery.of(context).size.height * 0.064,
                        backgroundColor: AppColors.primary,
                        borderRadius: 15.r,
                        onPressed: () {},
                        textStyle: TextStyles.font18BlackRegular),
                  ),
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
