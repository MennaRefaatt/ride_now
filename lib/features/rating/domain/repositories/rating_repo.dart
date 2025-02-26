abstract class RatingRepository {
  Future<void> submitDriverRating(String tripId, String driverId, double rating, String comment);
  Future<void> submitPassengerRating(String tripId, String passengerId, double rating, String comment);
}