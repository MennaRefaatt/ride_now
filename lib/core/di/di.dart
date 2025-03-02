import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ride_now/features/driver/driver_registration/data/repositories/d_repo_impl.dart';
import 'package:ride_now/features/driver/driver_registration/domain/repositories/d_repo_base.dart';
import 'package:ride_now/features/driver/driver_registration/domain/use_cases/fetch_brands_usecase.dart';
import 'package:ride_now/features/notifications/data/data_sources/notification_ds.dart';
import 'package:ride_now/features/notifications/data/repositories/notification_repo.dart';
import 'package:ride_now/features/notifications/presentation/manager/notification_cubit.dart';
import 'package:ride_now/features/privacy_policy/data/repositories/privacy_repo.dart';
import 'package:ride_now/features/privacy_policy/domain/use_cases/privacy_use_case.dart';
import 'package:ride_now/features/rating/data/repositories/rating_repo_impl.dart';
import 'package:ride_now/features/rating/domain/repositories/rating_repo.dart';
import 'package:ride_now/features/rating/domain/use_cases/submit_driver_rating.dart';
import 'package:ride_now/features/rating/domain/use_cases/submit_passenger_rating.dart';
import 'package:ride_now/features/rating/presentation/manager/rating_cubit.dart';
import 'package:ride_now/features/trip_module/trip/domain/use_cases/complete_trip_usecase.dart';
import 'package:ride_now/features/trip_module/trip/domain/use_cases/decline_trip_usecase.dart';
import 'package:ride_now/features/wallet/data/data_sources/wallet_data_source.dart';
import 'package:ride_now/features/wallet/domain/use_cases/get_wallet_use_case.dart';
import '../../features/driver/driver_registration/data/data_sources/d_remote_ds.dart';
import '../../features/driver/driver_registration/domain/use_cases/d_fetch_colors_usecase.dart';
import '../../features/driver/driver_registration/domain/use_cases/fetch_models_usecase.dart';
import '../../features/driver/driver_registration/domain/use_cases/submit_d_usecase.dart';
import '../../features/driver/driver_registration/presentation/manager/driver_registration_cubit.dart';
import '../../features/passenger/home/data/data_sources/home_remote_ds.dart';
import '../../features/passenger/home/data/repositories/home_repo_impl.dart';
import '../../features/passenger/home/domain/repositories/home_repo_base.dart';
import '../../features/passenger/home/presentation/manager/home_cubit.dart';
import '../../features/passenger/maps/data/data_source/data_source.dart';
import '../../features/passenger/maps/data/repo_impl/repo_impl.dart';
import '../../features/passenger/maps/domain/repo_base/repo_base.dart';
import '../../features/passenger/maps/domain/use_case/get_location_use_case.dart';
import '../../features/passenger/maps/domain/use_case/get_realtime_location_use_case.dart';
import '../../features/passenger/maps/domain/use_case/set_location_use_case.dart';
import '../../features/privacy_policy/data/data_sources/privacy_data_source.dart';
import '../../features/privacy_policy/presentation/manager/privacy_cubit.dart';
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
import '../../features/trip_module/trip/data/data_sources/trip_remote_ds.dart';
import '../../features/trip_module/trip/data/repositories/trip_repo_impl.dart';
import '../../features/trip_module/trip/domain/repositories/trip_repo_base.dart';
import '../../features/trip_module/trip/domain/use_cases/accept_trip_usecase.dart';
import '../../features/trip_module/trip/domain/use_cases/cancel_trip_usecase.dart';
import '../../features/trip_module/trip/domain/use_cases/create_trip_usecase.dart';
import '../../features/trip_module/trip/domain/use_cases/get_trip_details_usecase.dart';
import '../../features/trip_module/trip/domain/use_cases/get_trips_usecase.dart';
import '../../features/trip_module/trip/presentation/manager/trip_cubit.dart';
import '../../features/wallet/data/repositories/wallet_repo.dart';
import '../../features/wallet/domain/use_cases/charge_wallet_use_case.dart';
import '../../features/wallet/presentation/manager/wallet_cubit.dart';
import '../services/fcm/device_token_service.dart';
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

  // Register Firebase Storage
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Register Firebase Messaging
  sl.registerLazySingleton<DeviceTokenService>(() => DeviceTokenService());

  ///profile
  // Register Data Sources
  sl.registerLazySingleton<ProfileRemoteDS>(
      () => ProfileRemoteDSImpl(sl(), sl()));

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
  sl.registerLazySingleton<HomeRemoteDS>(() => HomeRemoteDSImpl());

  // Register Repositories
  sl.registerLazySingleton<HomeRepoBase>(
      () => HomeRepoImpl(homeRemoteDS: sl()));

  // Register Cubit
  sl.registerFactory(() => HomeCubit(homeRepoBase: sl()));

  ///trip
  sl.registerLazySingleton<TripRemoteDS>(() => TripRemoteDSImpl());
  sl.registerLazySingleton<TripRepoBase>(() => TripRepoImpl(sl()));
  sl.registerLazySingleton(() => CreateTripUseCase(tripRepoBase: sl()));
  sl.registerLazySingleton(() => AcceptTripUseCase(tripRepoBase: sl()));
  sl.registerLazySingleton(() => GetTripsUseCase(tripRepoBase: sl()));
  sl.registerLazySingleton(() => GetTripDetailsUseCase(tripRepoBase: sl()));
  sl.registerLazySingleton(() => CancelTripUseCase(sl()));
  sl.registerLazySingleton(() => CompleteTripUseCase(sl()));
  sl.registerLazySingleton(() => DeclineTripUseCase(sl()));

  sl.registerFactory(
    () => TripCubit(
        createTripUseCase: sl(),
        acceptTripUseCase: sl(),
        getTripsUseCase: sl(),
        declineTripUseCase: sl(),
        getTripDetailsUseCase: sl(),
        completeTripUseCase: sl(),
        cancelTripUseCase: sl()),
  );

  ///wallet
  sl.registerLazySingleton<WalletDataSource>(() => WalletDataSourceImpl(sl()));
  sl.registerLazySingleton<WalletRepoBase>(() => WalletRepo(sl()));
  sl.registerLazySingleton(() => GetWalletBalanceUseCase(sl()));
  sl.registerLazySingleton(() => ChargeWalletUseCase(sl()));
  sl.registerFactory(() => WalletCubit(sl(), sl()));

  ///privacy policy
  sl.registerLazySingleton<PrivacyDataSource>(
      () => PrivacyDataSourceImpl(sl()));
  sl.registerLazySingleton<PrivacyRepository>(
      () => PrivacyRepositoryImpl(sl()));
  sl.registerLazySingleton(() => FetchPrivacyPolicyUseCase(sl()));
  sl.registerFactory(() => PrivacyCubit(sl()));

  ///notifications
  sl.registerLazySingleton<NotificationDs>(() => NotificationDsImpl(sl()));
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(notificationDs: sl()));
  sl.registerFactory(() => NotificationsCubit(sl()));

  ///rating
  sl.registerLazySingleton<RatingRepository>(() => RatingRepositoryImpl());
  sl.registerLazySingleton(() => SubmitDriverRatingUseCase(sl()));
  sl.registerLazySingleton(() => SubmitPassengerRatingUseCase(sl()));

  sl.registerFactory(() => RatingCubit(sl()));
}
