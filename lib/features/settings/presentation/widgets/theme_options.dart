import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/cubits/app/app_cubit.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'options_container.dart';

class ThemeOptions extends StatelessWidget {
  const ThemeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = [S().light, S().dark, S().system];
    final appCubit = context.read<AppCubit>();
    final currentTheme = SharedPref.getBrightness();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: themes.map((theme) {
          bool isSelected =
              (theme == S().light && currentTheme == ThemeMode.light) ||
                  (theme == S().dark && currentTheme == ThemeMode.dark) ||
                  (theme == S().system && currentTheme == ThemeMode.system);

          return GestureDetector(
            onTap: () {
              ThemeMode selectedTheme = theme == S().light
                  ? ThemeMode.light
                  : theme == S().dark
                  ? ThemeMode.dark
                  : ThemeMode.system;

              appCubit.toggleThemeTo(selectedTheme);
              SharedPref.setBrightness(selectedTheme);
              Navigator.pop(context);
            },
            child: OptionContainer(
              text: theme,
              borderColor: AppColors.primary,
              backgroundColor: AppColors.primary,
              isSelected: isSelected,
              icon: theme == S().system
                  ? CupertinoIcons.device_phone_portrait
                  : theme == S().dark
                  ? CupertinoIcons.moon
                  : CupertinoIcons.sun_min,
            ),
          );
        }).toList(),
      ),
    );
  }
}
