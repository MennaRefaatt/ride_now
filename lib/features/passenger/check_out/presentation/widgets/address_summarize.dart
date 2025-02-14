import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/trip/data/data_sources/distance_helper/distance_helper.dart';
import '../../../../trip_module/trip/presentation/manager/trip_cubit.dart';
import '../../../maps/data/model/location_model.dart';
import '../../../maps/presentation/maps_args.dart';

class AddressSummarize extends StatefulWidget {
  AddressSummarize({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    required this.tripCubit,
    required this.fromLatLng,
    required this.toLatLng,
    required this.paymentMethod,
    required this.newToAddress,
    required this.newToLatLng,
    required this.newCost,
    required this.newPickedToAddress,
  }) {
    newToAddress = toAddress;
    newToLatLng = toLatLng;
  }

  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final String paymentMethod;
  String newToAddress = "";
  LatLng newToLatLng = const LatLng(0.0, 0.0);
  double newCost = 0.0;
  bool newPickedToAddress = false;

  @override
  State<AddressSummarize> createState() => _AddressSummarizeState();
}

class _AddressSummarizeState extends State<AddressSummarize> {
  @override
  void initState() {
    super.initState();
    widget.newToAddress = widget.toAddress;
    widget.newToLatLng = widget.toLatLng;
    _calculateCost();
  }

  void _pickDestinationAddress(BuildContext context) {
    Navigator.pushNamed(context, RoutingEndpoints.maps,
        arguments: MapsArgs(
          initialLatitude: widget.newToLatLng.latitude,
          initialLongitude: widget.newToLatLng.longitude,
        )).then((result) {
      if (result != null && result is LocationData) {
        setState(() {
          widget.newPickedToAddress = true;
          safePrint("New destination selected: ${result.address}");
          widget.newToAddress = result.address;
          widget.newToLatLng = LatLng(result.latitude, result.longitude);
        });
        _calculateCost();
      }
    });
  }

  void _calculateCost() async {
    final distanceText = await TripHelper().calculateDistance(
      widget.fromLatLng,
      widget.newToLatLng,
    );
    final distanceInKm = double.parse(distanceText.split(' ')[0]);
    widget.newCost = TripHelper().calculateCost(distanceInKm);
    widget.tripCubit.updateCost(widget.newCost.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(Icons.trip_origin, color: AppColors.primary),
                horizontalSpacing(10.w),
                Expanded(
                  child: Text(
                    widget.fromAddress,
                    style: TextStyles.font18BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.trip_origin, color: AppColors.red),
                horizontalSpacing(10.w),
                Expanded(
                  child: Text(
                    widget.newToAddress,
                    style: TextStyles.font18BlackRegular.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _pickDestinationAddress(context),
                  icon: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
