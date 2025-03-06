import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/cubits/app/app_cubit.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'options_container.dart';

class LanguageOptions extends StatelessWidget {
  const LanguageOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [S().english, S().arabic];
    final appCubit = context.read<AppCubit>();
    final currentLanguage = SharedPref.getCurrentLanguage();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: languages.map((lang) {
          bool isSelected =
              (lang == S().english && currentLanguage == 'en') ||
                  (lang == S().arabic && currentLanguage == 'ar');

          return GestureDetector(
            onTap: () {
              appCubit.changeLanguage(lang == S().english ? "en" : "ar");
              Navigator.pop(context);
            },
            child: OptionContainer(
              text: lang,
              borderColor: AppColors.primary,
              backgroundColor: AppColors.primary,
              isSelected: isSelected,
            ),
          );
        }).toList(),
      ),
    );
  }
}
