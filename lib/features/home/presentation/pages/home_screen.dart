import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/home/presentation/widgets/recent_ride.dart';
import 'package:ride_now/features/home/presentation/widgets/search_bar.dart';
import '../widgets/home_bar.dart';
import '../widgets/ride_categories.dart';
import '../widgets/saved_address.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                const HomeBar(),
                Container(
                  margin: EdgeInsets.all(15.sp),
                  child: Column(
                    children: [
                      verticalSpacing(350.h),
                      const RideCategories(),
                      verticalSpacing(20.h),
                      const SavedAddress(),
                      verticalSpacing(20.h),
                      const RecentRide(),
                    ],
                  ),
                )
              ],
            ),
            const SearchBarr()
          ],
        ),
      ),
    );
  }
}
