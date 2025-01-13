import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';

class TripTrackingRouteArgs {
  final TripTrackingArgs tripTrackingArgs;
  final bool isPassenger;

  TripTrackingRouteArgs({
    required this.tripTrackingArgs,
    required this.isPassenger,
  });
}
