import '../repositories/rating_repo.dart';

class SubmitDriverRatingUseCase {
  final RatingRepository repository;

  SubmitDriverRatingUseCase(this.repository);

  Future<void> call(String tripId, String driverId, double rating, String comment) {
    return repository.submitDriverRating(tripId, driverId, rating, comment);
  }
}