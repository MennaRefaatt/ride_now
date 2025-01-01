import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/trip_module/domain/use_cases/accept_trip_usecase.dart';
import 'package:ride_now/features/trip_module/domain/use_cases/create_trip_usecase.dart';
import 'package:ride_now/features/trip_module/domain/use_cases/get_trips_usecase.dart';

import '../../../../core/helpers/enums/trip_status.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../data/models/trip_model.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit({
    required this.acceptTripUseCase,
    required this.getTripsUseCase,
    required this.createTripUseCase
}) : super(TripInitial());
  AcceptTripUseCase acceptTripUseCase;
  GetTripsUseCase getTripsUseCase;
  CreateTripUseCase createTripUseCase;


  Future<void> getTrips() async {
    emit(TripsLoading());
    final userId =SharedPref.getString(key: MySharedKeys.userId)!;
    try {
      final trips = await getTripsUseCase.call(userId);
      emit(TripsLoaded(trips));
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }

  Future<void> createTrip(from, to) async {
    emit(CreateTripLoading());
    try {
      final tripModel = TripModel(
        driverId: "",
        tripId: "",
        passengerId: SharedPref.getString(key: MySharedKeys.userId)!,
        from: from,
        to: to,
        dateTime: DateTime.now(),
        price: "0",
        status: TripStatus.pending.name,
        passengerName: SharedPref.getString(key: MySharedKeys.userName)!,
        distance: "0",
      );
      await createTripUseCase.call(tripModel);
      emit(CreateTripLoaded());
    } catch (e) {
      emit(CreateTripError(e.toString()));
    }
  }

  Future<void> acceptTrip(TripModel tripModel) async {
    emit(AcceptTripLoading());
    try {
      final result = await acceptTripUseCase.call(tripModel);
      if (result) {
        emit(AcceptTripLoaded("Trip accepted successfully"));
      } else {
        emit(AcceptTripError("Failed to accept trip"));
      }
    } catch (e) {
      emit(AcceptTripError(e.toString()));
    }
  }
}
