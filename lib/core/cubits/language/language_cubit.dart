import 'package:bloc/bloc.dart';
import '../../helpers/shared_pref.dart';
import '../../helpers/shared_pref_keys.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitialState());
  static dynamic language;

  void changeLanguage() async {
    emit(ChangeLanguageState());
  }

  void changeLanguageToEn() async {
    await SharedPref.putString(key: MySharedKeys.currentLanguage, value: "en");
    emit(ChangeLanguageState());
  }

  void changeLanguageToAr() async {
    await SharedPref.putString(key: MySharedKeys.currentLanguage, value: "ar");
    emit(ChangeLanguageState());
  }
}
