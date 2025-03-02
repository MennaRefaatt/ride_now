part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppLoaded extends AppState {
  final ThemeMode themeMode;
  final Locale locale;

  AppLoaded({required this.themeMode, required this.locale});

  AppLoaded copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppLoaded(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
