import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:ride_now/core/components/drawer/drawer_items.dart';
import '../../../../core/components/app_bar.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../widgets/bottom_sheet_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: DefaultAppBar(
            text: S().settings,
            withDivider: false,
          )),
      drawer: const DrawerItems(),
      body: Container(
        margin: EdgeInsets.all(10.sp),
        child: Column(
          children: [
            settingsItems(
              text: S().phone,
              onTap: () {},
              theme: theme,
              returnedValue: SharedPref.getString(key: MySharedKeys.phone) == ""
                  ? S().missingPhoneNumber
                  : SharedPref.getString(key: MySharedKeys.phone),
            ),
            settingsItems(
              text: S().email,
              onTap: () {},
              theme: theme,
              returnedValue:
                  SharedPref.getString(key: MySharedKeys.email) ?? "",
            ),
            settingsItems(
              theme: theme,
              text: S().appLanguage,
              onTap: () => _showBottomSheet(context, S().language),
              returnedValue:
                  SharedPref.getString(key: MySharedKeys.currentLanguage) ??
                      "en",
            ),
            settingsItems(
              text: S().appTheme,
              theme: theme,
              onTap: () => _showBottomSheet(context, S().theme),
              returnedValue:
                  SharedPref.getString(key: MySharedKeys.theme) ?? "Light",
            ),
            AppButton(
              text: S().logout,
              backgroundColor: AppColors.primary,
              onPressed: () => _showBottomSheet(context, S().logout),
              textStyle: TextStyles.font14BlackRegular,
              borderRadius: 10.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsItems({
    required String text,
    required ThemeData theme,
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
                style: theme.brightness == Brightness.light
                    ? TextStyles.font18BlackRegular
                    : TextStyles.font18WhiteRegular,
              ),
            ),
            Text(
              returnedValue!,
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
