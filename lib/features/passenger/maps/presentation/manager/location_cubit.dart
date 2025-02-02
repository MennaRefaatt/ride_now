import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../auth/login/data/data_sources/firestore_service/firestore_service.dart';
import '../../domain/use_case/get_location_use_case.dart';
import '../../domain/use_case/get_realtime_location_use_case.dart';
import '../../domain/use_case/set_location_use_case.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetUserLocationUseCase getUserLocationUseCase;
  final SetLocationUseCase setLocationUseCase;
  final GetRealtimeLocationUseCase getRealTimeLocationUseCase;
  LatLng? selectedLocation;
  StreamSubscription<Position>? _positionSubscription;

  LocationCubit(this.getUserLocationUseCase, this.setLocationUseCase,
      this.getRealTimeLocationUseCase)
      : super(LocationInitial());

  Future<void> fetchUserLocation() async {
    emit(LocationLoading());
    try {
      final position = await getUserLocationUseCase.getCurrentLocation();
      final address = await _getAddressFromCoordinates(position);
      safePrint(address);
      updateCityToFirestore(address);
      emit(LocationLoaded(position, address));
    } catch (e) {
      emit(LocationError("Failed to get location"));
    }
  }

  void setMarker(LatLng location) async {
    try {
      selectedLocation = location;
      await setLocationUseCase.setLocation(location);
      final address = await _getAddressFromCoordinates(
        Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        ),
      );
      emit(LocationMarkerSet(location, address));
    } catch (e) {
      safePrint(e.toString());
    }
  }

  void trackDriverLocation() {
    emit(LocationLoading());
    _positionSubscription = getRealTimeLocationUseCase
        .getRealTimeLocationUpdates()
        .listen((position) async {
      final address = await _getAddressFromCoordinates(position);
      emit(LocationLoaded(position, address));
    }, onError: (e) {
      emit(LocationError("Failed to update driver location"));
    });
  }

  void stopTrackingLocation() {
    _positionSubscription?.cancel();
  }

  void updateCityToFirestore(String city) {
    FirestoreService(sl(), sl()).updateUserCityToFirestore(city);
    SharedPref.setString(key: MySharedKeys.city, value: city);
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}

Future<String> _getAddressFromCoordinates(Position position) async {
  return Future.microtask(() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        return place.street?.isNotEmpty == true
            ? place.street!
            : place.subLocality?.isNotEmpty == true
                ? place.subLocality!
                : place.locality?.isNotEmpty == true
                    ? place.locality!
                    : "Unknown Address";
      } else {
        safePrint("Placemark list is empty");
        return "Unknown Address";
      }
    } catch (e) {
      safePrint("Error fetching address: $e");
      return "Unknown Address";
    }
  });
}
