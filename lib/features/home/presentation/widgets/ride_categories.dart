import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/styles.dart';

class RideCategories extends StatelessWidget {
  const RideCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage:
                        NetworkImage("https://picsum.photos/250?image=$index"),
                  ),
                  Text(
                    "Category $index",
                    style: TextStyles.font14BlackRegular,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
