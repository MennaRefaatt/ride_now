part of 'rating_cubit.dart';

@immutable
sealed class RatingState {}

final class RatingInitial extends RatingState {}

class RatingSubmitLoading extends RatingState {}

class RatingSubmitSuccess extends RatingState {}

class RatingSubmitFailure extends RatingState {
  final String error;

  RatingSubmitFailure(this.error);
}
