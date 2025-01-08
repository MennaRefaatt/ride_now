import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../../auth/login/data/data_sources/firestore_service/firestore_service.dart';
import '../../domain/use_case/get_location_use_case.dart';
import '../../domain/use_case/get_realtime_location_use_case.dart';
import '../../domain/use_case/set_location_use_case.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetUserLocationUseCase getUserLocationUseCase;
  final SetLocationUseCase setLocationUseCase;
  final GetRealtimeLocationUseCase getRealTimeLocationUseCase;
  LatLng? selectedLocation;

  LocationCubit(this.getUserLocationUseCase, this.setLocationUseCase, this.getRealTimeLocationUseCase)
      : super(LocationInitial());

  Future<void> fetchUserLocation() async {
    emit(LocationLoading());
    try {
      final position = await getUserLocationUseCase.getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      final address = '${place.street}';
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
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks[2];
      final address = '${place.street}';
      safePrint("Address: $address");
      emit(LocationMarkerSet(location,address));
    } catch (e) {
      safePrint(e.toString());
    }

  }

  StreamSubscription<Position>? _positionSubscription;

  void trackDriverLocation() {
    emit(LocationLoading());
    _positionSubscription = getRealTimeLocationUseCase.getRealTimeLocationUpdates().listen((position) {
      emit(LocationLoaded(position, ''));
    }, onError: (e) {
      emit(LocationError("Failed to update driver location"));
    });
  }

  void stopTrackingLocation() {
    _positionSubscription?.cancel();
  }

  void updateCityToFirestore(String city) {
    FirestoreService().updateUserCityToFirestore(city);
    SharedPref.setString(key: MySharedKeys.city, value: city);
  }
}
