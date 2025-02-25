import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../passenger/maps/presentation/manager/location_cubit.dart';
import '../../data/models/trip_model.dart';
import '../manager/trip_cubit.dart';
import '../trip_tracking_args.dart';
import '../trip_tracking_route_args.dart';
import '../widgets/trip_details.dart';
import '../widgets/trip_tracking.dart';
import '../widgets/waiting_for_driver.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key, required this.args});

  final TripTrackingRouteArgs args;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final locationCubit = LocationCubit(sl(), sl(), sl());
  final tripCubit = TripCubit(
    declineTripUseCase: sl(),
    acceptTripUseCase: sl(),
    getTripsUseCase: sl(),
    createTripUseCase: sl(),
    getTripDetailsUseCase: sl(),
    cancelTripUseCase: sl(),
    completeTripUseCase: sl(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locationCubit..fetchUserLocation(),
        ),
        BlocProvider(
          create: (context) =>
              tripCubit..getTripDetails(widget.args.tripTrackingArgs.tripId),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<TripCubit, TripState>(
          builder: (context, state) {
            if (state is GetTripDetailsLoaded) {
              return StreamBuilder<DocumentSnapshot>(
                stream: tripCubit.listenToTripDetails(state.trip.tripId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    final tripData =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    if (tripData != null) {
                      final tripStatus = tripData['status'];
                      final driverData = tripData['driverData'];
                      final paymentStatus = tripData['paymentStatus'];
                      final driverLocation =
                          tripData['driverData']['driverLocation'] != null
                              ? LatLng(
                                  tripData['driverData']['driverLocation']
                                      ['latitude'],
                                  tripData['driverData']['driverLocation']
                                      ['longitude'],
                                )
                              : null;
                      final TripTrackingArgs updatedArgs = TripTrackingArgs(
                        fromAddress: widget.args.tripTrackingArgs.fromAddress,
                        toAddress: widget.args.tripTrackingArgs.toAddress,
                        tripId: widget.args.tripTrackingArgs.tripId,
                        fromLatLng: widget.args.tripTrackingArgs.fromLatLng,
                        toLatLng: widget.args.tripTrackingArgs.toLatLng,
                        driverLatLng: driverLocation,
                        tripStatus: tripStatus,
                      );
                      return Stack(
                        children: [
                          TripTracking(
                            args: updatedArgs,
                            driverLatLng: driverLocation!,
                          ),
                          if (tripStatus == TripStatus.accepted.name &&
                              driverData["driverId"] != "" &&
                              paymentStatus ==
                                  StripePaymentStatus.succeeded.name)
                            TripDetails(
                              tripModel: TripModel.fromJson(tripData),
                              isPassenger: widget.args.isPassenger,
                            ),
                          if (tripStatus != TripStatus.accepted.name &&
                              driverData["driverId"] == "")
                            WaitingForDriver(
                              tripId: widget.args.tripTrackingArgs.tripId,
                              isPassenger: true,
                            ),
                        ],
                      );
                    }
                  }

                  return Center(child: Text("No trip details available"));
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
