import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/enums/stripe_payment_status.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/passenger/check_out/presentation/widgets/check_out_buttons.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../trip_module/data/data_sources/distance_helper/distance_helper.dart';
import '../../../../trip_module/presentation/manager/trip_cubit.dart';

class AddressSummarize extends StatefulWidget {
  AddressSummarize({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    required this.tripCubit,
    required this.fromLatLng,
    required this.toLatLng,
    required this.paymentMethod,
    required this.paymentStatus,
  });
  final TripCubit tripCubit;
  final String fromAddress;
  final String toAddress;
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final String paymentMethod;
  String paymentStatus;
  @override
  State<AddressSummarize> createState() => _AddressSummarizeState();
}

class _AddressSummarizeState extends State<AddressSummarize> {
  late String toAddress;
  late String tripId;
  late LatLng toLatLng;

  @override
  void initState() {
    super.initState();
    toAddress = widget.toAddress;
    toLatLng = widget.toLatLng;
    _calculateCost();
  }

  void _pickDestinationAddress(BuildContext context) {
    Navigator.pushNamed(context, RoutingEndpoints.maps).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          toAddress = result['to'];
          toLatLng = LatLng(result['latitude'], result['longitude']);
        });
        _calculateCost();
      }
    });
  }

  void _calculateCost() async {
    final distanceText = await TripHelper().calculateDistance(
      widget.fromLatLng,
      toLatLng,
    );
    final distanceInKm = double.parse(distanceText.split(' ')[0]);
    final cost = TripHelper().calculateCost(distanceInKm);
    widget.tripCubit.updateCost(cost.toStringAsFixed(2));
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
                    toAddress,
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
            Spacer(),
            if (widget.paymentStatus==StripePaymentStatus.succeeded.name)
              CheckOutButtons(
                tripCubit: widget.tripCubit,
                fromAddress: widget.fromAddress,
                toAddress: toAddress,
                fromLatLng: widget.fromLatLng,
                toLatLng: toLatLng,
                paymentMethod: widget.paymentMethod,
              ),
          ],
        ),
      ),
    );
  }
}
