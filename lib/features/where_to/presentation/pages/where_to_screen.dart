import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/home/presentation/widgets/recent_ride.dart';
import 'package:ride_now/features/home/presentation/widgets/saved_address.dart';
import 'package:ride_now/features/where_to/presentation/widgets/where_to_bar.dart';

class WhereToScreen extends StatelessWidget {
  const WhereToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(15.sp),
              child: Column(children: [
                verticalSpacing(screenHeight * 0.5),
                const SavedAddress(),
                Divider(
                  thickness: 6,
                  color: Colors.grey.shade200,
                ),
                const RecentRide()
              ]),
            ),
            const WhereToBar()
          ],
        ),
      ),
    );
  }
}
