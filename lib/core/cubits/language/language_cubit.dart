import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helpers/shared_pref.dart';
import '../../helpers/shared_pref_keys.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitialState()) {
    loadSavedLanguage();
  }

  static String currentLanguage = "en";

  void changeLanguageToEn() async {
    await SharedPref.putString(key: MySharedKeys.currentLanguage, value: "en");
    currentLanguage = "en";
    emit(ChangeLanguageState());
  }

  void changeLanguageToAr() async {
    await SharedPref.putString(key: MySharedKeys.currentLanguage, value: "ar");
    currentLanguage = "ar";
    emit(ChangeLanguageState());
  }

  void loadSavedLanguage() async {
    currentLanguage = SharedPref.getCurrentLanguage();
    emit(ChangeLanguageState());
  }
}
