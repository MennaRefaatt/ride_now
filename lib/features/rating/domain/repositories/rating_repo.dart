abstract class RatingRepository {
  Future<void> submitDriverRating(String tripId, String driverId, double rating, String comment);
}