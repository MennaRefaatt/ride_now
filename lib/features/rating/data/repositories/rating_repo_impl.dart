import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/helpers/safe_print.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../domain/repositories/rating_repo.dart';

class RatingRepositoryImpl implements RatingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> submitDriverRating(
      String tripId, String driverId, double rating, String comment) async {
    try {
      final driverDoc =
          await _firestore.collection('drivers').doc(driverId).get();
      if (!driverDoc.exists) {
        throw Exception('Driver not found');
      }

      final driverData = driverDoc.data()!;
      final currentRating = driverData['rating']?['rating'] ?? 0.0;
      final currentRatingCount = driverData['rating']?['ratingCount'] ?? 0;

      final double newRating = (currentRating * currentRatingCount + rating) /
          (currentRatingCount + 1);

      await _firestore.collection('drivers').doc(driverId).update({
        'rating': {
          'rating': newRating,
          'ratingCount': currentRatingCount + 1,
          'comment':
              comment, // Store just the last comment or consider adding to a list
        }
      });

      final currentUserId = SharedPref.getString(key: MySharedKeys.userId);
      await _firestore.collection('users').doc(currentUserId).update({
        'ratingGivenCount': FieldValue.increment(1),
      });

      await _firestore.collection('ratings').add({
        'tripId': tripId,
        'driverId': driverId,
        'ratedBy': currentUserId,
        'rating': rating,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'driver_rating',
      });
    } catch (e) {
      safePrint("Error submitting driver rating: $e");
      throw Exception("Error submitting rating: $e");
    }
  }

  // Keep this method for interface compatibility but it won't be used
  @override
  Future<void> submitPassengerRating(
      String tripId, String passengerId, double rating, String comment) async {
    throw UnimplementedError('Passenger rating is not implemented');
  }
}
