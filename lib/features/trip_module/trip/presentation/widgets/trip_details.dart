import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/trip_module/trip/presentation/widgets/passenger_trip_details.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../data/models/trip_model.dart';
import 'driver_trip_details.dart';

class TripDetails extends StatefulWidget {
  const TripDetails(
      {super.key, required this.tripModel, required this.isPassenger});

  final TripModel tripModel;
  final bool isPassenger;

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  double _childSize = 0.3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: _childSize,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              double newHeight = _childSize -
                  details.primaryDelta! / MediaQuery.of(context).size.height;
              if (newHeight > 0.2 && newHeight < 0.8) {
                setState(() {
                  _childSize = newHeight;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? AppColors.black : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                  topLeft: Radius.circular(40.r),
                ),
              ),
              child: widget.isPassenger
                  ? PassengerTripDetails(
                      isPassenger: widget.isPassenger,
                      tripModel: widget.tripModel)
                  : DriverTripDetails(
                      isPassenger: widget.isPassenger,
                      tripModel: widget.tripModel),
            ),
          ),
        );
      },
    );
  }
}
