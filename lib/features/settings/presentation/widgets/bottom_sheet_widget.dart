import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/features/settings/presentation/widgets/theme_options.dart';
import '../../../../core/components/custom_bottom_sheet.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/login/data/data_sources/facebook_sign_in/facebook_sign_in.dart';
import '../../../auth/login/data/data_sources/google_sign_in/google_sign_in.dart';
import 'lang_options.dart';
import 'logout_options.dart';

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
            ? [LanguageOptions()]
            : isLogout
            ? [LogoutOptions(logout: _logout,)]
            : isTheme
            ? [ThemeOptions()]
            : [],
      ),
    );
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

