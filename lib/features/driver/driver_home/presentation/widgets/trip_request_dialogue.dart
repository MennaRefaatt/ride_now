import 'package:flutter/cupertino.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/driver/driver_home/presentation/widgets/trip_request_card.dart';
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
  late List<AnimationController?> animationControllers;
  late List<Animation<Offset>?> slideAnimations;

  @override
  void initState() {
    super.initState();
    animationControllers = [];
    slideAnimations = [];
    widget.tripCubit.getTrips();
  }

  // void startSlideAnimation(int index) {
  //   if (animationControllers[index] != null) return;
  //
  //   final controller = AnimationController(
  //     duration: const Duration(seconds: 30),
  //     vsync: this,
  //   );
  //   animationControllers[index] = controller;
  //   slideAnimations[index] = Tween<Offset>(
  //     begin: Offset.zero,
  //     end: const Offset(-1.5, 0),
  //   ).animate(
  //     CurvedAnimation(parent: controller, curve: Curves.easeInOut),
  //   );
  //
  //   controller.forward();
  // }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripModel>>(
      stream: widget.tripCubit.listenToTrips(),
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

        final trips = snapshot.data!;
        animationControllers =
            List<AnimationController?>.filled(trips.length, null);
        slideAnimations = List<Animation<Offset>?>.filled(trips.length, null);

        return ListView.builder(
          itemCount: trips.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            final trip = trips[index];
            final timeRemaining =
                trip.dateTime.difference(DateTime.now()).inSeconds;

            if (timeRemaining <= 0) {
              //startSlideAnimation(index);
            }

            return AnimatedBuilder(
              animation:
                  animationControllers[index] ?? AlwaysStoppedAnimation(0),
              builder: (context, child) {
                return SlideTransition(
                  position: slideAnimations[index] ??
                      AlwaysStoppedAnimation(Offset.zero),
                  child: child,
                );
              },
              child: TripRequestCard(
                trip: trip,
                timeRemaining: timeRemaining,
                tripCubit: widget.tripCubit,
              ),
            );
          },
        );
      },
    );
  }
}
