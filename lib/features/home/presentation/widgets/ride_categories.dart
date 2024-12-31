import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_network_image.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/home/presentation/manager/home_cubit.dart';
import 'package:ride_now/features/home/presentation/widgets/ride_description.dart';
import '../../../../core/components/app_icon.dart';

class RideCategories extends StatefulWidget {
  const RideCategories({super.key});

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
    selectedIndex = 0; // Default to the first category.
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
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded) {
                final defaultCategoryIndex = state.categories
                    .indexWhere((category) => category.name == "Ride");

                if (defaultCategoryIndex != -1 && selectedIndex == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      selectedIndex = defaultCategoryIndex;
                    });
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
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
                              : (isHovered
                                  ? AppColors.red
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppNetworkImage(
                                  borderRadius: BorderRadius.circular(10.r),
                                  imageUrl: state.categories[index].image,
                                  height: 70.h,
                                  width: 100.w,
                                ),
                                horizontalSpacing(5.w),
                                if (isSelected)
                                  InkWell(
                                    onTap: () => _showBottomSheet(
                                        context,
                                        state.categories[index].image,
                                        state.categories[index].name,
                                        state.categories[index].description),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                            verticalSpacing(5.h),
                            Text(
                              state.categories[index].name,
                              style: TextStyles.font24BlackBold.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
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
      builder: (_) => RideDescription(
        image: image,
        text: text,
        description: description,
      ),
    );
  }
}
