import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_button.dart';

import '../../../core/components/app_bar.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/services/routing/routing_endpoints.dart';
import '../../../core/theming/app_colors.dart';
import '../../../generated/l10n.dart';

class DriverNotEligibleScreen extends StatelessWidget {
  const DriverNotEligibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: DefaultAppBar(
            text: S().accessDenied,
            withDivider: false,
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            verticalSpacing(10),
            Text(
              S().youAreNotEligible,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(10),
            Text(
              S().pleaseCompleteYourRegistration,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(10),
            AppButton(
                text: S().ok,
                backgroundColor: AppColors.primary,
                onPressed: () => Navigator.pushReplacementNamed(context, RoutingEndpoints.driverOnBoarding),
                textStyle: TextStyles.font18WhiteBold),
          ],
        ),
      ),
    );
  }
}
