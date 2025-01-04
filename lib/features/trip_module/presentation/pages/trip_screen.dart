import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import 'package:ride_now/features/trip_module/presentation/widgets/waiting_for_driver.dart';
import '../../../../../core/di/di.dart';
import '../../../../core/helpers/enums/trip_status.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/trip_cubit.dart';
import '../widgets/trip_details.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key, required this.args});

  final TripTrackingArgs args;

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final locationCubit = LocationCubit(sl(), sl(), sl());
  final tripCubit = TripCubit(
    acceptTripUseCase: sl(),
    getTripsUseCase: sl(),
    createTripUseCase: sl(),
    getTripDetailsUseCase: sl(),
    cancelTripUseCase: sl(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locationCubit..fetchUserLocation(),
        ),
        BlocProvider(
          create: (context) => tripCubit..getTripDetails(widget.args.tripId),
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
                      final driverId = tripData['driverData']['driverId'];
                      if (tripStatus != TripStatus.accepted.name &&
                          driverId == "") {
                        return WaitingForDriver(args: widget.args);
                      }
                      return TripDetails(
                        args: widget.args,
                        state: AcceptTripLoaded(
                            "accepted",
                            state
                                .trip),
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
