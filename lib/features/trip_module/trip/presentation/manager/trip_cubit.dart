import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/secure_storage/secure_storage.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../../core/helpers/secure_storage/secure_keys.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../data/data_sources/distance_helper/distance_helper.dart';
import '../../data/models/trip_model.dart';
import '../../domain/use_cases/accept_trip_usecase.dart';
import '../../domain/use_cases/cancel_trip_usecase.dart';
import '../../domain/use_cases/create_trip_usecase.dart';
import '../../domain/use_cases/get_trip_details_usecase.dart';
import '../../domain/use_cases/get_trips_usecase.dart';

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
  String paymentStatus = "";
  void updatePaymentStatus(String status) {
    paymentStatus = status;
    emit(TripPaymentStatusUpdated(status));
  }

  void updateCost(String costText) {
    cost = double.parse(costText);
    emit(TripCostUpdated(cost));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToTripDetails(
      String tripId) {
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
        .debounceTime(const Duration(milliseconds: 300))
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return TripModel.fromJson(doc.data());
      }).toList();
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

  Future<void> createTrip(
      String from,
      LatLng fromLatLng,
      String to,
      LatLng toLatLng,
      String paymentMethod,
      bool moreThan4Passengers,
      String comment,
      double cost,
      ) async {
    emit(CreateTripLoading());
    try {
      final tripHelper = TripHelper();
      String distance = await tripHelper.calculateDistance(fromLatLng, toLatLng, unit: 'km');
      String estimatedTime = await tripHelper.calculateEstimatedArrivalTime(fromLatLng, toLatLng, 30);
      final passengerToken = await SecureStorageService.readData(SecureKeys.deviceToken) ?? '';

      final tripModel = TripModel(
        tripId: "", // TripId will be generated after creating the trip
        from: from,
        moreThan4Passengers: moreThan4Passengers,
        comment: comment,
        paymentMethod: paymentMethod,
        to: to,
        estimatedTime: estimatedTime,
        paymentStatus: StripePaymentStatus.holding.name,
        status: TripStatus.pending.name,
        dateTime: DateTime.now(),
        price: cost.toString(),
        distance: distance,
        fromLatLng: fromLatLng,
        toLatLng: toLatLng,
        driverData: DriverData(
          driverId: "",
          driverName: "",
          driverPhone: "",
          driverImage: "",
          carColor: "",
          carModel: "",
          carNumber: "",
          driverToken: "",
          driverLocation: LatLng(0, 0),
        ),
        passengerData: PassengerData(
          passengerId: SharedPref.getString(key: MySharedKeys.userId)!,
          passengerName: SharedPref.getString(key: MySharedKeys.userName)!,
          passengerPhone: SharedPref.getString(key: MySharedKeys.phone)!,
          passengerToken: passengerToken,
        ),
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
