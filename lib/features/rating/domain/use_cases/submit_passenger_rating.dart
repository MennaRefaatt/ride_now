import '../repositories/rating_repo.dart';

class SubmitPassengerRatingUseCase {
  final RatingRepository repository;

  SubmitPassengerRatingUseCase(this.repository);

  Future<void> call(String tripId, String passengerId, double rating, String comment) {
    return repository.submitPassengerRating(tripId, passengerId, rating, comment);
  }
}