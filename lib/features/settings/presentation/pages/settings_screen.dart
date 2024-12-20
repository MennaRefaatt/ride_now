import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/features/home/presentation/widgets/drawer_items.dart';
import '../../../../core/components/app_bar.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../widgets/bottom_sheet_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(text: 'S().Settings')),
      drawer: const DrawerItems(),
      body: Container(
        margin: EdgeInsets.all(10.sp),
        child: Column(
          children: [
            SettingsItems(
              text: S().phone,
              onTap: () {},
              returnedValue: 'S().Missing Phone Number',
            ),
            SettingsItems(
              text: S().email,
              onTap: () {},
            ),
            SettingsItems(
              text: S().appLanguage,
              onTap: () => _showBottomSheet(context, 'language'),
            ),
            SettingsItems(
              text: "S().appTheme",
              onTap: () => _showBottomSheet(context, 'theme'),
            ),
            AppButton(
              text: S().logout,
              backgroundColor: AppColors.primary,
              onPressed: () => _showBottomSheet(context, 'logout'),
              textStyle: TextStyles.font14BlackRegular,
              borderRadius: 10.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget SettingsItems({
    required String text,
    required VoidCallback onTap,
    String? returnedValue,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyles.font18BlackRegular,
              ),
            ),
            Text(
              returnedValue ?? "",
              style: TextStyles.font14grayRegular,
            ),
            Icon(
              Icons.navigate_next,
              color: AppColors.semiGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BottomSheetWidget(type: type),
    );
  }
}
