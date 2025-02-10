import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_bar.dart';
import 'package:ride_now/core/components/drawer_items.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../core/di/di.dart';
import '../../../core/helpers/enums/user_type.dart';
import '../../../core/helpers/shared_pref.dart';
import '../../../core/helpers/shared_pref_keys.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/services/routing/routing_endpoints.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/styles.dart';
import '../../../generated/l10n.dart';
import '../../auth/login/data/data_sources/firestore_service/firestore_service.dart';

class DriverOnBoarding extends StatelessWidget {
  const DriverOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.semiGrey.withOpacity(0.1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: DefaultAppBar(
          text: "",
          withDivider: false,
        ),
      ),
      drawer: DrawerItems(),
      body: Container(
        margin: EdgeInsets.all(10.sp),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S().getIncomeWithUs,
                    style: TextStyles.font24BlackBold,
                  ),
                  verticalSpacing(20),
                  getIncomeWithUs(S().flexibleHours),
                  verticalSpacing(10),
                  getIncomeWithUs(S().yourPrices),
                  verticalSpacing(10),
                  getIncomeWithUs(S().lowServicePayments),
                ],
              ),
            ),
            verticalSpacing(20),
            InkWell(
              onTap: () => Navigator.pushReplacementNamed(
                  context, RoutingEndpoints.driverRegistration),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.car_detailed),
                    horizontalSpacing(10),
                    Expanded(
                      child: Text(
                        S().driver,
                        style: TextStyles.font18BlackRegular,
                      ),
                    ),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
            verticalSpacing(20),
            AppButton(
              text: S().goToPassengerMode,
              backgroundColor: AppColors.primary,
              width: MediaQuery.of(context).size.width,
              borderRadius: 10.r,
              onPressed: () {
                saveModeToFirestore(UserType.passenger.name);
                Navigator.pushReplacementNamed(
                    context, RoutingEndpoints.passengerHome);
              },
              textStyle: TextStyles.font18WhiteBold,
            ),
          ],
        ),
      ),
    );
  }

  void saveModeToFirestore(String mode) {
    FirestoreService(sl(), sl()).saveUserModeToFirestore(mode);
    SharedPref.setString(key: MySharedKeys.type, value: mode);
  }

  Widget getIncomeWithUs(String text) {
    return Row(
      children: [
        Icon(CupertinoIcons.check_mark_circled_solid),
        horizontalSpacing(10.w),
        Text(
          text,
          style: TextStyles.font18BlackRegular,
        ),
      ],
    );
  }
}
