import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_network_image.dart';
import 'package:ride_now/core/components/custom_bottom_sheet.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/passenger/home/data/models/category_model.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/ride_description.dart';

import '../../../../../core/components/app_icon.dart';
import '../../../../../generated/l10n.dart';

class RideCategories extends StatefulWidget {
  const RideCategories({super.key, required this.categories});
  final List<CategoryModel> categories;

  @override
  RideCategoriesState createState() => RideCategoriesState();
}

class RideCategoriesState extends State<RideCategories> {
  int? hoveredIndex;
  int? selectedIndex;
  final ScrollController _scrollController = ScrollController();

  void _scrollToNext() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.offset + 200.w,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final defaultCategoryIndex = widget.categories
        .indexWhere((category) => category.name == "Ride");

    if (defaultCategoryIndex != -1) {
      final rideCategory = widget.categories.removeAt(defaultCategoryIndex);
      widget.categories.insert(0, rideCategory);
      selectedIndex = 0;
    } else {
      selectedIndex = 0;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final isHovered = hoveredIndex == index;
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.2)
                        : (isHovered ? AppColors.red : Colors.transparent),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppNetworkImage(
                            borderRadius: BorderRadius.circular(10.r),
                            imageUrl: widget.categories[index].image,
                            height: 70.h,
                            width: 100.w,
                          ),
                          horizontalSpacing(5.w),
                          if (isSelected)
                            InkWell(
                              onTap: () => _showBottomSheet(
                                  context,
                                  widget.categories[index].image,
                                  widget.categories[index].name,
                                  widget.categories[index].description),
                              child: Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                      verticalSpacing(5.h),
                      Text(
                        widget.categories[index].name,
                        style: TextStyles.font24BlackBold.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
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

  void _showBottomSheet(
      BuildContext context,
      String image,
      String text,
      String description,
      ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => CustomBottomSheet(
        title: S().rideDescription,
        child: RideDescription(
          image: image,
          text: text,
          description: description,
        ),
      ),
    );
  }
}
