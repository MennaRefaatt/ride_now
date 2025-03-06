import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';
import 'options_container.dart';

class LogoutOptions extends StatelessWidget {
  const LogoutOptions({super.key, required this.logout});
  final Future<void> Function() logout;
  @override
  Widget build(BuildContext context) {
    final options = [S().yes, S().no];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final bool yesIsSelected = option == S().yes;

          return GestureDetector(
            onTap: () async {
              if (yesIsSelected) {
                await logout().then((_) {
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
            child: OptionContainer(
              text: option,
              isSelected: yesIsSelected,
              borderColor: AppColors.red,
              backgroundColor: AppColors.red,
              noBackgroundColor:  AppColors.primary.withValues(alpha: 0.1),
              noBorderColor: AppColors.primary.withValues(alpha: 0.2),
              yesIsSelected: TextStyles.font18BlackRegular,
            ),
          );
        }).toList(),
      ),
    );
  }
}
