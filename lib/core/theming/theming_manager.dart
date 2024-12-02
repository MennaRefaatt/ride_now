import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/shared_pref.dart';
import '../helpers/shared_pref_keys.dart';
import 'app_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightTheme) {
    init();
  }

  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    emit(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
    SharedPref.putBoolean(key: MySharedKeys.isDarkMode, value: isDarkMode);
  }

  void init() {
    isDarkMode = SharedPref.getBoolean(
        key: MySharedKeys.isDarkMode, defaultValue: false);
    emit(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
  }
}
