import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/cubits/app/app_cubit.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import '../../../../core/components/custom_bottom_sheet.dart';
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
    final isLanguage = type == S().language;
    final isLogout = type == S().logout;
    final isTheme = type == S().theme;

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

  /// Language Options
  List<Widget> _buildLanguageOptions(BuildContext context) {
    final languages = [S().english, S().arabic];
    final appCubit = context.read<AppCubit>();
    final currentLanguage = SharedPref.getCurrentLanguage();

    return languages.map((lang) {
      bool isSelected = (lang == S().english && currentLanguage == 'en') ||
          (lang == S().arabic && currentLanguage == 'ar');

      return ListTile(
        title: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
          child: Text(lang, style: TextStyles.font18BlackRegular),
        ),
        onTap: () {
          if (lang == S().english) {
            appCubit.changeLanguage("en");
          } else {
            appCubit.changeLanguage("ar");
          }
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  /// Theme Options
  List<Widget> _buildThemeOptions(BuildContext context) {
    final themes = [S().light, S().dark, S().systemDefault];
    final appCubit = context.read<AppCubit>();
    final currentTheme = SharedPref.getBrightness();

    return themes.map((theme) {
      bool isSelected = (theme == S().light && currentTheme == Brightness.light) ||
          (theme == S().dark && currentTheme == Brightness.dark) ||
          (theme == S().systemDefault && currentTheme == ThemeMode.system);

      return ListTile(
        title: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
          child: Text(theme, style: TextStyles.font18BlackRegular),
        ),
        onTap: () {
          if (theme == S().light) {
            appCubit.toggleThemeTo(ThemeMode.light);
          } else if (theme == S().dark) {
            appCubit.toggleThemeTo(ThemeMode.dark);
          } else {
            appCubit.toggleThemeTo(ThemeMode.system);
          }
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  /// Logout Options
  List<Widget> _buildLogoutOptions(BuildContext context) {
    final options = [S().yes, S().no];

    return options.map(
          (option) {
        final bool yesIsSelected = option == S().yes;

        return ListTile(
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: yesIsSelected
                  ? AppColors.red.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.2),
            ),
            child: Text(option, style: TextStyles.font18BlackRegular),
          ),
          onTap: () async {
            if (yesIsSelected) {
              await _logout().then((value) {
                Navigator.pushReplacementNamed(context, RoutingEndpoints.login);
                safePrint("Logged out successfully");
                SharedPref.clear();
                SharedPref.clearUserData();
              });
            } else {
              Navigator.pop(context);
            }
          },
        );
      },
    ).toList();
  }

  /// Logout Function
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
