import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/data/models/trip_model.dart';

class RecentRide extends StatelessWidget {
  const RecentRide({super.key, required this.trips});
  final List<TripModel> trips;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: trips.length,
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
                        Text(trips[index].to),
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
