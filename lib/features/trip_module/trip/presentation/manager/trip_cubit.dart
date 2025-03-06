import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/secure_storage/secure_storage.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/features/driver/driver_registration/data/models/driver_registration_model.dart';
import 'package:ride_now/features/trip_module/trip/domain/use_cases/complete_trip_usecase.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../../core/helpers/secure_storage/secure_keys.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../data/data_sources/distance_helper/distance_helper.dart';
import '../../data/models/trip_model.dart';
import '../../domain/use_cases/accept_trip_usecase.dart';
import '../../domain/use_cases/cancel_trip_usecase.dart';
import '../../domain/use_cases/create_trip_usecase.dart';
import '../../domain/use_cases/decline_trip_usecase.dart';
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
    required this.completeTripUseCase,
    required this.declineTripUseCase,
  }) : super(TripInitial());

  AcceptTripUseCase acceptTripUseCase;
  GetTripsUseCase getTripsUseCase;
  GetTripDetailsUseCase getTripDetailsUseCase;
  CreateTripUseCase createTripUseCase;
  CancelTripUseCase cancelTripUseCase;
  CompleteTripUseCase completeTripUseCase;
  DeclineTripUseCase declineTripUseCase;

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

  Stream<List<TripModel>> listenToTrips(String driverId) {
    final driverStream = FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId)
        .snapshots();

    return driverStream.switchMap((driverSnapshot) {
      if (!driverSnapshot.exists) {
        return Stream.value([]);
      }

      final driverData = driverSnapshot.data()!;
      List<String> declinedTrips =
          List<String>.from(driverData['declinedTrips'] ?? []);

      final tripsStream = FirebaseFirestore.instance
          .collection('trips')
          .where('status', isEqualTo: TripStatus.pending.name)
          .snapshots()
          .map((tripsSnapshot) {
        return tripsSnapshot.docs
            .map((doc) => TripModel.fromJson(doc.data()))
            .where((trip) => !declinedTrips.contains(trip.tripId))
            .toList();
      });

      return tripsStream;
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
      String selectedCategory) async {
    emit(CreateTripLoading());
    try {
      final tripHelper = TripHelper();
      String distance =
          await tripHelper.calculateDistance(fromLatLng, toLatLng, unit: 'km');
      String estimatedTime = await tripHelper.calculateEstimatedArrivalTime(
          fromLatLng, toLatLng, 30);
      final passengerToken =
          await SecureStorageService.readData(SecureKeys.deviceToken) ?? '';

      final tripModel = TripModel(
        tripId: "",
        from: from,
        selectedCategory: selectedCategory,
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
            passengerImage: SharedPref.getString(key: MySharedKeys.picture)!),
      );

      await createTripUseCase.call(tripModel);

      final createdTrip = await getTripDetailsUseCase.call(tripModel.tripId);

      safePrint("Trip created successfully.");
      safePrint(createdTrip);

      emit(CreateTripLoaded(createdTrip));
    } catch (e) {
      safePrint("Error creating trip: $e");
      emit(CreateTripError(e.toString()));
    }
  }

  Future<List<DriverRegistrationModel>> getAvailableDrivers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .where('driverTripStatus',
              isEqualTo: 'available')
          .get();

      return querySnapshot.docs
          .map((doc) => DriverRegistrationModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      safePrint("Error fetching available drivers: $e");
      return [];
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
      if (tripId.isEmpty) {
        throw Exception('Trip ID cannot be empty');
      }

      emit(CancelTripLoading());
      final result = await cancelTripUseCase.call(tripId);
      emit(CancelTripSuccess(result.toString()));
    } catch (error) {
      safePrint("Error canceling trip: $error");
      emit(CancelTripError(error.toString()));
    }
  }

  Future<void> completeTrip(
      String tripId, BuildContext context, bool isPassenger) async {
    try {
      emit(CompleteTripLoading());

      await completeTripUseCase.call(tripId).then((_) async {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip completed successfully!')),
          );
        }
        safePrint("tripId: $tripId");
        final driverIdd = SharedPref.getString(key: MySharedKeys.driverId);
        safePrint("driverIdd: $driverIdd");
        if (isPassenger) {
          final tripDoc = await FirebaseFirestore.instance
              .collection('trips')
              .doc(tripId)
              .get();

          if (tripDoc.exists) {
            final tripData = tripDoc.data();
            safePrint("🚀 Trip Data Retrieved: $tripData");

            if (driverIdd!.isNotEmpty) {
              await SharedPref.putBoolean(key: MySharedKeys.showRating, value: true);
              await SharedPref.putString(key: MySharedKeys.ratedUserId, value: driverIdd);
              await SharedPref.putString(key: MySharedKeys.ratedTripId, value: tripId);

              Future.delayed(Duration(milliseconds: 300), () {
                bool savedShowRating = SharedPref.getBoolean(key: MySharedKeys.showRating);
                String savedRatedUserId = SharedPref.getString(key: MySharedKeys.ratedUserId) ?? "";
                String savedTripId = SharedPref.getString(key: MySharedKeys.ratedTripId) ?? "";

                safePrint("🔄 إعادة القراءة بعد الحفظ: showRating=$savedShowRating, ratedUserId=$savedRatedUserId, tripId=$savedTripId");
              });
            }
          } else {
            safePrint("🚨 Error: Trip document does not exist in Firestore!");
          }
        }
      });

      emit(CompleteTripLoaded("Trip completed successfully"));
    } catch (error) {
      emit(CompleteTripError(error.toString()));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing trip: ${error.toString()}')),
        );
      }
    }
  }

  Future<void> declineTrip(String driverId, String tripId) async {
    try {
      emit(DeclineTripLoading());

      final storedDriverId = SharedPref.getString(key: MySharedKeys.driverId);
      safePrint("📌 Driver ID from SharedPref: $storedDriverId");
      safePrint("📌 Driver ID passed to function: $driverId");

      if (storedDriverId != driverId) {
        safePrint(
            "⚠️ MISMATCH: The stored driver ID and function argument are different!");
      }
      final driverDoc = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get();

      if (!driverDoc.exists) {
        throw Exception("⚠️ Driver document not found in Firestore!");
      }

      await declineTripUseCase.call(driverId, tripId);
      emit(DeclineTripLoaded("Trip declined successfully"));
    } catch (error) {
      safePrint("❌ Error declining trip: $error");
      emit(DeclineTripError(error.toString()));
    }
  }
}
