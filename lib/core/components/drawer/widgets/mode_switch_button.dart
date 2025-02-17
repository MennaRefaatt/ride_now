import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../../theming/app_colors.dart';
import '../../../theming/styles.dart';
class ModeSwitchButton extends StatelessWidget {
  final bool isDriverMode;
  final VoidCallback onPressed;

  const ModeSwitchButton(
      {required this.isDriverMode, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: isDriverMode ? S().passengerMode : S().driverMode,
      backgroundColor: AppColors.primary,
      onPressed: onPressed,
      borderRadius: 10.r,
      textStyle: TextStyles.font14BlackRegular,
    );
  }
}
