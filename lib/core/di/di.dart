import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ride_now/features/driver/driver_registration/data/repositories/d_repo_impl.dart';
import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';
import 'package:ride_now/features/driver/driver_registration/domain/use_cases/fetch_brands_usecase.dart';
import 'package:ride_now/features/home/data/data_sources/category_remote_ds.dart';
import 'package:ride_now/features/home/data/repositories/categories_repo_impl.dart';
import 'package:ride_now/features/home/presentation/manager/home_cubit.dart';
import '../../features/driver/driver_registration/data/data_sources/d_remote_ds.dart';
import '../../features/driver/driver_registration/domain/use_cases/d_fetch_colors_usecase.dart';
import '../../features/driver/driver_registration/domain/use_cases/fetch_models_usecase.dart';
import '../../features/driver/driver_registration/domain/use_cases/submit_d_usecase.dart';
import '../../features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
import '../../features/home/domain/repositories/category_repo_base.dart';
import '../../features/maps/data/data_source/data_source.dart';
import '../../features/maps/data/repo_impl/repo_impl.dart';
import '../../features/maps/domain/repo_base/repo_base.dart';
import '../../features/maps/domain/use_case/get_location_use_case.dart';
import '../../features/maps/domain/use_case/get_realtime_location_use_case.dart';
import '../../features/maps/domain/use_case/set_location_use_case.dart';
import '../../features/profile/data/data_sources/city_remote_ds.dart';
import '../../features/profile/data/data_sources/profile_remote_ds.dart';
import '../../features/profile/data/repositories/city_repo_impl.dart';
import '../../features/profile/data/repositories/profile_repo_impl.dart';
import '../../features/profile/domain/repositories/city_repo_base.dart';
import '../../features/profile/domain/repositories/profile_repo_base.dart';
import '../../features/profile/domain/use_cases/get_city_usecase.dart';
import '../../features/profile/domain/use_cases/get_profile_usecase.dart';
import '../../features/profile/domain/use_cases/save_city_usecase.dart';
import '../../features/profile/domain/use_cases/save_profile_usecase.dart';
import '../../features/profile/presentation/manager/city_cubit.dart';
import '../../features/profile/presentation/manager/profile_cubit.dart';
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

  // Register Firebase Firestore instance
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  ///profile
  // Register Data Sources
  sl.registerLazySingleton<ProfileRemoteDS>(() => ProfileRemoteDSImpl(sl()));

  // Register Repositories
  sl.registerLazySingleton<ProfileRepoBase>(() => ProfileRepoImpl(sl()));

  // Register Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => SaveProfileUseCase(sl()));

  // Register Cubit
  sl.registerFactory(() => ProfileCubit(sl(), sl()));

  /// City
  // Register City Data Sources
  sl.registerLazySingleton<CityRemoteDS>(() => CityRemoteDSImpl(sl()));

  // Register City Repositories
  sl.registerLazySingleton<CityRepoBase>(() => CityRepoImpl(sl()));

  // Register City Use Cases
  sl.registerLazySingleton(() => GetCitiesUseCase(sl()));
  sl.registerLazySingleton(() => SaveCityUseCase(sl()));

  // Register City Cubit
  sl.registerFactory(() => CityCubit(sl(), sl()));

  ///driver registration
  sl.registerLazySingleton<DriverRegistrationRemoteDataSource>(
      () => DriverRegistrationRemoteDataSourceImpl());
  sl.registerLazySingleton<DRepoBase>(() => DRepoImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => FetchBrandsUseCase(sl()));
  sl.registerLazySingleton(() => FetchModelsUseCase(sl()));
  sl.registerLazySingleton(() => FetchColorsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitDriverRegistrationUseCase(sl()));

  sl.registerFactory(() => DriverRegistrationCubit(
        fetchBrandsUseCase: sl(),
        fetchColorsUseCase: sl(),
        fetchModelsUseCase: sl(),
        submitDriverRegistrationUseCase: sl(),
      ));

  ///home
  // Register Data Sources
  sl.registerLazySingleton<CategoriesRemoteDS>(() => CategoriesRemoteDSImpl());

  // Register Repositories
  sl.registerLazySingleton<CategoriesRepoBase>(() => CategoriesRepoImpl(categoriesRemoteDS: sl()));

  // Register Cubit
  sl.registerFactory(() => HomeCubit(categoriesRepo: sl()));

}
