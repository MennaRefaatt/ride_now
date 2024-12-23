import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/maps/data/data_source/data_source.dart';
import '../../features/maps/data/repo_impl/repo_impl.dart';
import '../../features/maps/domain/repo_base/repo_base.dart';
import '../../features/maps/domain/use_case/get_location_use_case.dart';
import '../../features/maps/domain/use_case/get_realtime_location_use_case.dart';
import '../../features/maps/domain/use_case/set_location_use_case.dart';
import '../services/network/api_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Dio
  sl.registerLazySingleton(() => Dio());

  // Register ApiService
  sl.registerLazySingleton(() => ApiService());


  //maps
  sl.registerLazySingleton(
          () => GetRealtimeLocationUseCase(sl<LocationRepository>()));
  sl.registerLazySingleton(
          () => GetUserLocationUseCase(sl<LocationRepository>()));
  sl.registerLazySingleton(() => SetLocationUseCase(sl<LocationRepository>()));
  sl.registerLazySingleton<LocationRepository>(
          () => LocationRepositoryImpl(sl()));
  sl.registerLazySingleton<GeolocationDataSource>(
          () => GeolocationDataSourceImpl());

}
