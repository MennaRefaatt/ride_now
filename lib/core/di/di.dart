import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/maps/data/data_source/data_source.dart';
import '../../features/maps/data/repo_impl/repo_impl.dart';
import '../../features/maps/domain/repo_base/repo_base.dart';
import '../../features/maps/domain/use_case/get_location_use_case.dart';
import '../../features/maps/domain/use_case/get_realtime_location_use_case.dart';
import '../../features/maps/domain/use_case/set_location_use_case.dart';
import '../../features/profile/data/data_sources/profile_remote_ds.dart';
import '../../features/profile/data/repositories/profile_repo_impl.dart';
import '../../features/profile/domain/repositories/profile_repo_base.dart';
import '../../features/profile/domain/use_cases/get_profile_usecase.dart';
import '../../features/profile/domain/use_cases/save_profile_usecase.dart';
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

}
