part of 'trip_cubit.dart';

@immutable
sealed class TripState {}

final class TripInitial extends TripState {}

final class TripsLoading extends TripState {}

final class TripsLoaded extends TripState {
  final List<TripModel> trips;
  TripsLoaded(this.trips);
}

final class TripsError extends TripState {
  final String message;
  TripsError(this.message);
}

final class CreateTripLoading extends TripState {}

final class CreateTripLoaded extends TripState {}

final class CreateTripError extends TripState {
  final String message;
  CreateTripError(this.message);
}

final class AcceptTripLoading extends TripState {}

final class AcceptTripLoaded extends TripState {
  final String message;
  AcceptTripLoaded(this.message);
}

final class AcceptTripError extends TripState {
  final String message;
  AcceptTripError(this.message);
}
