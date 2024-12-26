import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/profile/data/models/city_model.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../domain/use_cases/get_city_usecase.dart';
import '../../domain/use_cases/save_city_usecase.dart';
part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  final GetCitiesUseCase getCitiesUseCase;
  final SaveCityUseCase saveCityUseCase;

  CityCubit(this.getCitiesUseCase, this.saveCityUseCase) : super(CityInitial());

  void fetchCities(String query) async {
    emit(CityLoading());
    try {
      final cities = await getCitiesUseCase();
      emit(CityLoaded(cities));
    } catch (e) {
      emit(CityError("Failed to load cities"));
    }
  }

  void selectCity( String cityName) async {
    emit(CitySaving());
    try {
      await saveCityUseCase(SharedPref.getString(key: MySharedKeys.userId)!, cityName);
      safePrint("Saved city: $cityName");
      emit(CitySaved());
    } catch (e) {
      emit(CityError("Failed to save city"));
    }
  }
}
