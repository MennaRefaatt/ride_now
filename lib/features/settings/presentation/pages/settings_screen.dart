import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/spacing.dart';
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
        ),
      ),
      drawer: const DrawerItems(),
      body: Container(
        margin: EdgeInsets.all(10.sp),
        child: Column(
          children: [
            settingsItems(
              icon: CupertinoIcons.phone,
              text: S().phone,
              onTap: () {},
              theme: theme,
              returnedValue: SharedPref.getString(key: MySharedKeys.phone) == ""
                  ? S().missingPhoneNumber
                  : SharedPref.getString(key: MySharedKeys.phone),
            ),
            settingsItems(
              icon: CupertinoIcons.mail,
              text: S().email,
              onTap: () {},
              theme: theme,
              returnedValue:
                  SharedPref.getString(key: MySharedKeys.email) ?? "",
            ),
            settingsItems(
              icon: CupertinoIcons.globe,
              text: S().appLanguage,
              theme: theme,
              onTap: () => _showBottomSheet(context, S().language),
              returnedValue: SharedPref.getCurrentLanguage(),
            ),
            settingsItems(
              icon: CupertinoIcons.moon,
              text: S().appTheme,
              theme: theme,
              onTap: () => _showBottomSheet(context, S().theme),
              returnedValue: _getThemeModeString(SharedPref.getBrightness()),
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
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.semiGrey,
            ),
            horizontalSpacing(10),
            Expanded(
              child: Text(
                text,
                style: theme.brightness == Brightness.light
                    ? TextStyles.font18BlackBold
                    : TextStyles.font18WhiteBold,
              ),
            ),
            if (returnedValue != null)
              Text(
                returnedValue,
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

  String _getThemeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return S().light;
      case ThemeMode.dark:
        return S().dark;
      case ThemeMode.system:
        return S().system;
    }
  }
}
