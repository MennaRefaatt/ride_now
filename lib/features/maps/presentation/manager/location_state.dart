part of 'location_cubit.dart';

class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final Position position;
  final String address;

  LocationLoaded(this.position, this.address);
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}

class LocationMarkerSet extends LocationState {
  final LatLng location;

  LocationMarkerSet(this.location);
}
