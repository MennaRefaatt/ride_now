import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import '../../../../core/components/app_icon.dart';

class RideCategories extends StatefulWidget {
  const RideCategories({super.key});

  @override
  RideCategoriesState createState() => RideCategoriesState();
}

class RideCategoriesState extends State<RideCategories> {
  int? hoveredIndex; // To track which container is hovered
  int? selectedIndex; // To track which container is selected
  final ScrollController _scrollController = ScrollController();

  // Function to scroll to the next position
  void _scrollToNext() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 200.w, // Adjust step size as needed
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = 0; // Set the default selected index to 0 (first item)
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              final isHovered = hoveredIndex == index;
              final isSelected = selectedIndex == index;

              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex =
                          index; // Set the selected index when clicked
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.all(10.sp),
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                              .withOpacity(0.2) // Show color when selected
                          : (isHovered
                              ? AppColors.red
                              : Colors
                                  .transparent), // No color when not hovered and not selected
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              "https://picsum.photos/250?image=$index",
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8.w),
                            if (isSelected)
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                        verticalSpacing(5.h),
                        Text(
                          "Category",
                          style: TextStyles.font24BlackBold.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 0,
            child: AppIcon(
              icon: Icons.navigate_next,
              backgroundColor: Colors.white,
              iconColor: Colors.black87,
              withShadow: true,
              navigation: _scrollToNext,
            ),
          ),
        ],
      ),
    );
  }
}
