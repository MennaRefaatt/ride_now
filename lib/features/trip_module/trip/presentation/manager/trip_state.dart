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

final class GetTripDetailsLoading extends TripState {}

final class GetTripDetailsLoaded extends TripState {
  final TripModel trip;
  GetTripDetailsLoaded(this.trip);
}

final class GetTripDetailsError extends TripState {
  final String message;
  GetTripDetailsError(this.message);
}

final class CancelTripLoading extends TripState {}

final class CancelTripSuccess extends TripState {
  final String message;
  CancelTripSuccess(this.message);
}

final class CancelTripError extends TripState {
  final String message;
  CancelTripError(this.message);
}

final class CreateTripLoading extends TripState {}

final class CreateTripLoaded extends TripState {
  final TripModel trip;
  CreateTripLoaded(this.trip);
}

final class CreateTripError extends TripState {
  final String message;
  CreateTripError(this.message);
}

final class AcceptTripLoading extends TripState {}

final class AcceptTripLoaded extends TripState {
  final String message;
  final TripModel trip;
  AcceptTripLoaded(this.message, this.trip);
}

final class AcceptTripError extends TripState {
  final String message;
  AcceptTripError(this.message);
}

class TripCostUpdated extends TripState {
  final double cost;

  TripCostUpdated(this.cost);
}

class TripPaymentStatusUpdated extends TripState {
  final String status;

  TripPaymentStatusUpdated(this.status);
}
