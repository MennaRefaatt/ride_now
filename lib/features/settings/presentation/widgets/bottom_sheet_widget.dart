import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/login/data/data_sources/facebook_sign_in/facebook_sign_in.dart';
import '../../../auth/login/data/data_sources/google_sign_in/google_sign_in.dart';

class BottomSheetWidget extends StatelessWidget {
  final String type;

  const BottomSheetWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isLanguage = type == 'language';
    final isLogout = type == 'logout';
    final isTheme = type == 'theme';

    return Container(
      padding: EdgeInsets.all(20.sp),
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLanguage
                ? S().changeLanguage
                : isLogout
                    ? S().areYouSuretyYouWantToLogout
                    : "S().selectTheme",
            style: TextStyles.font24BlackBold,
          ),
          verticalSpacing(10.h),
          Divider(color: AppColors.semiGrey),
          verticalSpacing(10.h),
          Expanded(
            child: ListView(
              children: isLanguage
                  ? _buildLanguageOptions(context)
                  : isLogout
                      ? _buildLogoutOptions(context)
                      : isTheme
                          ? _buildThemeOptions(context)
                          : [],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLanguageOptions(BuildContext context) {
    final languages = [S().english, S().arabic];
    return languages
        .map(
          (lang) => ListTile(
            title: Text(lang, style: TextStyles.font18BlackRegular),
            onTap: () {
              // TODO: Implement language selection logic
              Navigator.pop(context);
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildThemeOptions(BuildContext context) {
    final themes = ["S().light", "S().dark", "S().systemDefault"];
    return themes
        .map(
          (theme) => ListTile(
            title: Text(theme, style: TextStyles.font18BlackRegular),
            onTap: () {
              // TODO: Implement theme selection logic
              Navigator.pop(context);
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildLogoutOptions(BuildContext context) {
    final options = [S().yes, S().no];
    return options
        .map(
          (option) => ListTile(
            title: Text(option, style: TextStyles.font18BlackRegular),
            onTap: () async {
              if (option == S().yes) {
                await _logout().then((value) {
                  Navigator.pushReplacementNamed(
                      context, RoutingEndpoints.login);
                  safePrint("Logged out successfully");
                  SharedPref.clear();
                  SharedPref.clearUserData();
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
        )
        .toList();
  }

  Future<void> _logout() async {
    try {
      await DSFacebookSignInImpl().signOutFacebook();
      await GoogleSignInServiceImpl().signOutGoogle();
      safePrint("Logged out successfully");
    } catch (e) {
      safePrint("Logout failed: $e");
    }
  }
}
