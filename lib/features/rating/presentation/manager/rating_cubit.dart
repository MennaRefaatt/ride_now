import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/repositories/rating_repo.dart';
part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingRepository _ratingRepository;

  RatingCubit(this._ratingRepository) : super(RatingInitial());

  void submitRating({
    required String tripId,
    required String ratedUserId,
    required double rating,
    required String comment,
    required bool isDriver,
  }) async {
    emit(RatingSubmitLoading());
    try {
      if (!isDriver) {
        await _ratingRepository.submitDriverRating(
          tripId,
          ratedUserId,
          rating,
          comment,
        );
        emit(RatingSubmitSuccess());
      } else {
        emit(RatingSubmitFailure("Driver rating functionality is not available"));
      }
    } catch (e) {
      emit(RatingSubmitFailure(e.toString()));
    }
  }
}
