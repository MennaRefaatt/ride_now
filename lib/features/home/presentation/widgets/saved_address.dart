import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';

class SavedAddress extends StatelessWidget {
  const SavedAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S().savedAddresses,
                style: TextStyles.font18BlackRegular
                    .copyWith(fontWeight: FontWeight.bold)),
            Text("S().addMore", style: TextStyles.font14primaryBold),
          ],
        ),
        ListView.builder(
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
                            Icons.home_filled,
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
                      const Icon(Icons.navigate_next)
                    ],
                  ),
                ),
                if (index != 1)
                Divider(
                  color: Colors.grey.shade300,
                )
              ]);
            }),
      ],
    );
  }
}
