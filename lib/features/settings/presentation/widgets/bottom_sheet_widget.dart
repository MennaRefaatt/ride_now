import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';

class BottomSheetWidget extends StatelessWidget {
  final String type;

  const BottomSheetWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isLanguage = type == 'language';
    final isLogout = type == 'logout';
    return Container(
      padding: EdgeInsets.all(20.sp),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
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
                    : 'S().Select Theme',
            style: TextStyles.font18BlackRegular,
          ),
          Divider(color: AppColors.semiGrey),
          Expanded(
            child: ListView(
              children: isLanguage
                  ? _buildLanguageOptions()
                  : isLogout
                      ? _buildLogoutOptions()
                      : _buildThemeOptions(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLanguageOptions() {
    final languages = [S().english, S().arabic];
    return languages
        .map((lang) => ListTile(
              title: Text(lang, style: TextStyles.font18BlackRegular),
              onTap: () {
                // Implement language selection logic here
              },
            ))
        .toList();
  }

  List<Widget> _buildThemeOptions() {
    final themes = ['S().Light', 'S().Dark', 'S().System Default'];
    return themes
        .map((theme) => ListTile(
              title: Text(theme, style: TextStyles.font18BlackRegular),
              onTap: () {
                // Implement theme selection logic here
              },
            ))
        .toList();
  }

  List<Widget> _buildLogoutOptions() {
    final logout = [S().yes, S().no];
    return logout
        .map((logout) => ListTile(
              title: Text(logout, style: TextStyles.font18BlackRegular),
              onTap: () {
                // Implement theme selection logic here
              },
            ))
        .toList();
  }
}
