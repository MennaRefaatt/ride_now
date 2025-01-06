import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/trip_module/domain/use_cases/accept_trip_usecase.dart';
import 'package:ride_now/features/trip_module/domain/use_cases/create_trip_usecase.dart';
import 'package:ride_now/features/trip_module/domain/use_cases/get_trips_usecase.dart';

import '../../../../core/helpers/enums/trip_status.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../data/data_sources/distance_helper/distance_helper.dart';
import '../../data/models/trip_model.dart';
import '../../domain/use_cases/cancel_trip_usecase.dart';
import '../../domain/use_cases/get_trip_details_usecase.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit({
    required this.acceptTripUseCase,
    required this.getTripsUseCase,
    required this.getTripDetailsUseCase,
    required this.createTripUseCase,
    required this.cancelTripUseCase,
  }) : super(TripInitial());

  AcceptTripUseCase acceptTripUseCase;
  GetTripsUseCase getTripsUseCase;
  GetTripDetailsUseCase getTripDetailsUseCase;
  CreateTripUseCase createTripUseCase;
  CancelTripUseCase cancelTripUseCase;

  double cost = 0.0;

  Stream<DocumentSnapshot> listenToTripDetails(String tripId) {
    if (tripId.isEmpty) {
      throw Exception("Trip ID is required");
    }
    return FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .snapshots();
  }

  Stream<List<TripModel>> listenToTrips() {
    return FirebaseFirestore.instance
        .collection('trips')
        .where('status', isEqualTo: TripStatus.pending.name)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => TripModel.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> getTrips() async {
    emit(TripsLoading());
    final userId = SharedPref.getString(key: MySharedKeys.userId)!;
    try {
      final trips = await getTripsUseCase.call(userId);
      emit(TripsLoaded(trips));
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }

  Future<void> getTripDetails(String tripId) async {
    emit(GetTripDetailsLoading());
    try {
      final trip = await getTripDetailsUseCase.call(tripId);
      emit(GetTripDetailsLoaded(trip));
    } catch (e) {
      emit(GetTripDetailsError(e.toString()));
    }
  }

  Future<void> createTrip(String from, String to) async {
    emit(CreateTripLoading());
    try {
      TripHelper tripHelper = TripHelper();
      String distance =
          await tripHelper.calculateDistance(from, to, unit: 'km');
      double distanceInKm = double.parse(distance.split(" ")[0]);
      double tripCost = tripHelper.calculateCost(distanceInKm);
      DriverData driverData = DriverData(
          driverId: "",
          driverName: "",
          driverPhone: "",
          driverImage: "",
          carColor: "",
          carModel: "",
          carNumber: "",
          driverLocation: DriverLocation(
            latitude: 0.0,
            longitude: 0.0,
          )
          );

      PassengerData passengerData = PassengerData(
        passengerId: SharedPref.getString(key: MySharedKeys.userId)!,
        passengerName: SharedPref.getString(key: MySharedKeys.userName)!,
        passengerPhone: "",
      );

      final tripModel = TripModel(
        tripId: "",
        from: from,
        to: to,
        status: TripStatus.pending.name,
        dateTime: Timestamp.now(),
        price: tripCost.toString(),
        distance: distance,
        driverData: driverData,
        passengerData: passengerData,
      );
      await createTripUseCase.call(tripModel);

      final createdTrip = await getTripDetailsUseCase.call(tripModel.tripId);

      safePrint("Trip created successfully.");
      safePrint(createdTrip);
      emit(CreateTripLoaded(createdTrip));
    } catch (e) {
      safePrint(e.toString());
      emit(CreateTripError(e.toString()));
    }
  }

  Future<void> acceptTrip(TripModel tripModel, DriverData driverData) async {
    try {
      emit(AcceptTripLoading());
      await acceptTripUseCase.call(tripModel, driverData);
      emit(AcceptTripLoaded("Trip accepted successfully", tripModel));
    } catch (e) {
      emit(AcceptTripError(e.toString()));
    }
  }

  Future<void> cancelTrip(String tripId) async {
    try {
      emit(CancelTripLoading());
      final result = await cancelTripUseCase.call(tripId);
      emit(CancelTripSuccess(result.toString()));
    } catch (error) {
      emit(CancelTripError(error.toString()));
    }
  }
}
