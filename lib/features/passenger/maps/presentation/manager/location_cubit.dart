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
  Timer? _toggleTimer;
  bool isTracking = false;

  LocationCubit(this.getUserLocationUseCase, this.setLocationUseCase,
      this.getRealTimeLocationUseCase)
      : super(LocationInitial());

  void _toggleLocationUpdates(Function fetchFunction) {
    if (_toggleTimer != null && _toggleTimer!.isActive) {
      return;
    }
    _toggleTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (isTracking) {
        isTracking = false;
        _positionSubscription?.cancel();
        safePrint("Tracking paused for 3 seconds");
      } else {
        fetchFunction();
        Future.delayed(const Duration(seconds: 2), () {
          isTracking = true;
          safePrint("Tracking resumed for 2 seconds");
        });
      }
    });
  }

  Future<void> fetchUserLocation() async {
    if (selectedLocation != null) {
      safePrint("Manual selection detected, skipping fetchUserLocation");
      return;
    }

    emit(LocationLoading());

    _toggleLocationUpdates(() async {
      try {
        final position = await getUserLocationUseCase.getCurrentLocation();
        final address = await _getAddressFromCoordinates(position);

        safePrint("Auto-updating location: $address");
        updateCityToFirestore(address);

        if (selectedLocation == null) {
          emit(LocationLoaded(position, address));
        }
      } catch (e) {
        emit(LocationError("Failed to get location"));
      }
    });
  }

  void trackDriverLocation() {
    emit(LocationLoading());
    _toggleLocationUpdates(() {
      _positionSubscription = getRealTimeLocationUseCase
          .getRealTimeLocationUpdates()
          .listen((position) async {
        final address = await _getAddressFromCoordinates(position);
        emit(LocationLoaded(position, address));
      }, onError: (e) {
        emit(LocationError("Failed to update driver location"));
      });
    });
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
      safePrint(address);
      emit(LocationMarkerSet(location, address));
    } catch (e) {
      safePrint(e.toString());
    }
  }

  void stopTrackingLocation() {
    _positionSubscription?.cancel();
    _toggleTimer?.cancel();
    _toggleTimer = null;
    _positionSubscription = null;
    isTracking = false;
    emit(LocationInitial());
  }

  @override
  Future<void> close() {
    stopTrackingLocation();
    return super.close();
  }

  void updateCityToFirestore(String city) {
    FirestoreService(sl(), sl()).updateUserCityToFirestore(city);
    SharedPref.setString(key: MySharedKeys.city, value: city);
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
