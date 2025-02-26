import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../manager/driver_registration_cubit.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.progressAnimation,
    required this.pageController,
    required this.formKeys,
    required this.driverCubit,
    required this.currentPage,
    required this.onboardingData,
    required this.onNext,
  });

  final int currentPage;
  final Animation<double> progressAnimation;
  final PageController pageController;
  final List<GlobalKey<FormState>> formKeys;
  final DriverRegistrationCubit driverCubit;
  final List<Map<String, String>> onboardingData;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(15.0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${currentPage + 1} of ${onboardingData.length}",
                  style: theme.brightness == Brightness.dark
                      ? TextStyles.font24WhiteBold
                      : TextStyles.font24BlackBold,
                  textDirection: TextDirection.ltr,
                ),
                verticalSpacing(10),
                AnimatedBuilder(
                  animation: progressAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: LinearProgressIndicator(
                        value: progressAnimation.value,
                        backgroundColor: theme.brightness == Brightness.dark
                            ? AppColors.semiGrey.withValues(alpha: 0.6)
                            : AppColors.semiGrey.withValues(alpha: 0.2),
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.r),
                        minHeight: 10.h,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (currentPage != 0)
            FloatingActionButton(
              backgroundColor: AppColors.semiGrey.withValues(alpha: 0.2),
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              elevation: 0,
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: AppButton(
              backgroundColor: AppColors.primary,
              borderRadius: 10.r,
              width: MediaQuery.of(context).size.width * 0.3,
              textStyle: TextStyles.font18BlackRegular,
              text: currentPage == onboardingData.length - 1
                  ? S().finish
                  : S().next,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
