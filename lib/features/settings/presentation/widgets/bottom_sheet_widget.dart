import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import '../../../../core/components/custom_bottom_sheet.dart';
import '../../../../core/cubits/language/language_cubit.dart';
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

    return CustomBottomSheet(
      title: type,
      child: Column(
        children: isLanguage
            ? _buildLanguageOptions(context)
            : isLogout
                ? _buildLogoutOptions(context)
                : isTheme
                    ? _buildThemeOptions(context)
                    : [],
      ),
    );
  }

  List<Widget> _buildLanguageOptions(BuildContext context) {
    final languages = [S().english, S().arabic];
    final languageCubit = context.read<LanguageCubit>();
    final currentLanguage =
        SharedPref.getCurrentLanguage();

    return languages.map((lang) {
      bool isSelected = (lang == S().english && currentLanguage == 'en') ||
          (lang == S().arabic && currentLanguage == 'ar');

      return ListTile(
        title: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Text(lang, style: TextStyles.font18BlackRegular),
        ),
        onTap: () {
          if (lang == S().english) {
            languageCubit.changeLanguageToEn();
            SharedPref.setCurrentLanguage('en');
          } else {
            languageCubit.changeLanguageToAr();
            SharedPref.setCurrentLanguage('ar');
          }
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  List<Widget> _buildThemeOptions(BuildContext context) {
    final themes = [S().light, S().dark, S().systemDefault];
    return themes
        .map(
          (theme) => ListTile(
            title: Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Text(theme, style: TextStyles.font18BlackRegular)),
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
            title: Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Text(option, style: TextStyles.font18BlackRegular)),
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
