import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class OptionContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color borderColor;
  final Color backgroundColor;
  final Color? noBorderColor;
  final Color? noBackgroundColor;
  final IconData? icon;
  final ThemeMode? currentTheme;
  final TextStyle? yesIsSelected;
  const OptionContainer({
    super.key,
    required this.text,
    required this.borderColor,
    required this.backgroundColor,
    this.noBorderColor,
    this.icon,
    this.currentTheme,
    this.noBackgroundColor,
    this.yesIsSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20.sp),
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: isSelected
              ? borderColor.withValues(alpha: 0.2)
              : noBorderColor ??Colors.transparent,
          width: 5.w,
        ),
        color: isSelected
            ? backgroundColor.withValues(alpha: 0.1)
            : noBackgroundColor ?? AppColors.semiGrey.withValues(alpha: 0.2),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 40.sp,
              color: isSelected
                  ? AppColors.primary
                  : currentTheme == ThemeMode.dark
                  ? Colors.white
                  : Colors.grey,
            ),
          Text(
            text,
            style: isSelected
                ? TextStyles.font18primaryRegular
                : theme.brightness == Brightness.dark
                ? TextStyles.font18WhiteRegular
                : TextStyles.font18BlackRegular,
          ),
        ],
      ),
    );
  }
}
