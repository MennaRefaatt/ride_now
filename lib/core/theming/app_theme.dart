
import 'package:flutter/material.dart';
import 'package:ride_now/core/theming/styles.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Inter',
    highlightColor: Colors.transparent,
    dividerColor: Colors.grey.shade200,
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onSurface: Colors.black87,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primary),
    splashColor: Colors.transparent,
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: AppColors.primary),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      titleSmall: TextStyles.font12WhiteRegular,
      titleMedium: TextStyles.font14WhiteMedium,
      titleLarge: TextStyles.font18WhiteBold,
      bodySmall: TextStyles.font12primaryRegular,
      bodyMedium: TextStyles.font14primaryRegular,
      bodyLarge: TextStyles.font18primaryRegular,
      labelSmall: TextStyles.font12primarySemiBold,
      labelMedium: TextStyles.font14primarySemiBold,
      labelLarge: TextStyles.font18primarySemiBold,
      headlineSmall: TextStyles.font12primaryMedium,
      headlineMedium: TextStyles.font14primaryMedium,
      headlineLarge: TextStyles.font18primaryMedium,
      displaySmall: TextStyles.font14WhiteRegular,
      displayMedium: TextStyles.font18WhiteRegular,
      displayLarge: TextStyles.font34WhiteMedium,
    ),

  );

  static ThemeData darkTheme = ThemeData(
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Colors.white),
    fontFamily: 'Inter',
    highlightColor: Colors.transparent,
    dividerColor: Colors.grey.shade800,
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade800,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      onSurface: Colors.white70,
    ),
    splashColor: Colors.transparent,
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.dark,
    hintColor: TextStyles.font14grayRegular.color,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: TextTheme(
      titleSmall: TextStyles.font12WhiteBold,
      titleMedium: TextStyles.font14WhiteBold,
      titleLarge: TextStyles.font18WhiteBold,
      bodySmall: TextStyles.font12WhiteRegular,
      bodyMedium: TextStyles.font14WhiteRegular,
      bodyLarge: TextStyles.font18WhiteRegular,
      labelSmall: TextStyles.font12WhiteSemiBold,
      labelMedium: TextStyles.font14WhiteSemiBold,
      labelLarge: TextStyles.font18WhiteSemiBold,
      headlineSmall: TextStyles.font12WhiteMedium,
      headlineMedium: TextStyles.font14WhiteMedium,
      headlineLarge: TextStyles.font18WhiteMedium,
    ),
  );
}
