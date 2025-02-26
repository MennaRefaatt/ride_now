import 'package:flutter/cupertino.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/driver/driver_home/presentation/widgets/trip_request_card.dart';
import '../../../../../core/helpers/shared_pref.dart';
import '../../../../../core/helpers/shared_pref_keys.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';

class TripRequestsDialogue extends StatefulWidget {
  const TripRequestsDialogue({super.key, required this.tripCubit});
  final TripCubit tripCubit;

  @override
  State<TripRequestsDialogue> createState() => _TripRequestsDialogueState();
}

class _TripRequestsDialogueState extends State<TripRequestsDialogue>
    with TickerProviderStateMixin {
  late List<AnimationController> animationControllers = [];
  late List<Animation<Offset>> slideAnimations = [];
  late List<TripModel> trips = [];

  @override
  void initState() {
    super.initState();
    animationControllers = [];
    slideAnimations = [];
    widget.tripCubit.getTrips();
  }

  void startSlideAnimation(int index, String tripId) {
    if (animationControllers[index].isAnimating) return;

    animationControllers[index].forward();
    widget.tripCubit.declineTrip(driverId!, tripId);
  }

  void removeTrip(int index, String tripId) {
    if (index < trips.length) {
      widget.tripCubit.declineTrip(driverId!, tripId);
      setState(() {
        trips.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  final driverId = SharedPref.getString(key: MySharedKeys.userId);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripModel>>(
      stream: widget.tripCubit.listenToTrips(driverId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasError) {
          safePrint(snapshot.error);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No trip requests available'),
          );
        }

        trips = List.from(snapshot.data!);
        animationControllers = List.generate(trips.length, (index) {
          return AnimationController(
            duration: const Duration(seconds: 1),
            vsync: this,
          );
        });

        slideAnimations = List.generate(trips.length, (index) {
          return Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.5, 0),
          ).animate(
            CurvedAnimation(
              parent: animationControllers[index],
              curve: Curves.easeInOut,
            ),
          );
        });
        return ListView.builder(
          itemCount: trips.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            final trip = trips[index];
            Future.delayed(const Duration(seconds: 30), () {
              if (mounted) {
                startSlideAnimation(index, trip.tripId);
              }
            });

            return AnimatedBuilder(
              animation: animationControllers[index],
              builder: (context, child) {
                return SlideTransition(
                  position: slideAnimations[index],
                  child: child,
                );
              },
              child: TripRequestCard(
                trip: trip,
                tripCubit: widget.tripCubit,
                onTimerEnd: () {
                  if (mounted) {
                    Future.delayed(const Duration(seconds: 30), () {
                      if (mounted) {
                        startSlideAnimation(index, trip.tripId);
                      }
                    });
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
