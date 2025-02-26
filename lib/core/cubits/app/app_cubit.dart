import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helpers/shared_pref.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(AppLoaded(
    themeMode: SharedPref.getBrightness(),
    locale: Locale(SharedPref.getCurrentLanguage()),
  ));

  void toggleThemeTo(ThemeMode newTheme) {
    if (state is AppLoaded) {
      final currentState = state as AppLoaded;
      SharedPref.setBrightness(newTheme);
      emit(currentState.copyWith(themeMode: newTheme));
    }
  }

  void changeLanguage(String languageCode) {
    if (state is AppLoaded) {
      final currentState = state as AppLoaded;
      final newLocale = Locale(languageCode);

      SharedPref.setCurrentLanguage(languageCode);
      emit(currentState.copyWith(locale: newLocale));
    }
  }
}