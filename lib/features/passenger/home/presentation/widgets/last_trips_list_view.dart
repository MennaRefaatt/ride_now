import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../manager/home_cubit.dart';

class LastTripsListView extends StatefulWidget {
  LastTripsListView(
      {super.key,
      required this.lastTrips,
      required this.disappear,
      required this.cubit});
  final List<TripModel> lastTrips;
  bool disappear;
  final HomeCubit cubit;

  @override
  State<LastTripsListView> createState() => _LastTripsListViewState();
}

class _LastTripsListViewState extends State<LastTripsListView> {
  @override
  Widget build(BuildContext context) {
    List<TripModel> uniqueTrips = [];
    Set<String> uniqueLatLngs = {};

    for (var trip in widget.lastTrips) {
      String latLngKey = '${trip.toLatLng.latitude},${trip.toLatLng.longitude}';
      if (!uniqueLatLngs.contains(latLngKey)) {
        uniqueTrips.add(trip);
        uniqueLatLngs.add(latLngKey);
      }
    }

    return Visibility(
      visible: !widget.disappear,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.6,
        child: uniqueTrips.length == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.cubit.toController.text = uniqueTrips[0].to;
                      widget.cubit.toLatLng = uniqueTrips[0].toLatLng;
                      if (widget.cubit.toController.text == uniqueTrips[0].to) {
                        setState(() {
                          widget.disappear = true;
                        });
                        Navigator.pushNamed(
                          context,
                          RoutingEndpoints.checkOut,
                          arguments: CheckOutArgs(
                            fromAddress: widget.cubit.fromController.text,
                            toAddress: widget.cubit.toController.text,
                            fromLatLng: widget.cubit.fromLatLng!,
                            toLatLng: widget.cubit.toLatLng!,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.sp),
                      margin: EdgeInsets.all(1.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      width: uniqueTrips[0].to.length > 15
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        uniqueTrips[0].to,
                        style: TextStyles.font18BlackRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              )
            : Directionality(
                textDirection:
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: ListView.builder(
                  itemCount: uniqueTrips.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      final selectedTrip = uniqueTrips[index];
                      widget.cubit.toController.text = selectedTrip.to;
                      widget.cubit.toLatLng = selectedTrip.toLatLng;
                      widget.cubit.fromLatLng = selectedTrip.fromLatLng;

                      if (widget.cubit.toLatLng != null &&
                          widget.cubit.fromLatLng != null) {
                        setState(() {
                          widget.disappear = true;
                        });
                        Navigator.pushNamed(
                          context,
                          RoutingEndpoints.checkOut,
                          arguments: CheckOutArgs(
                            fromAddress: widget.cubit.fromController.text,
                            toAddress: widget.cubit.toController.text,
                            fromLatLng: widget.cubit.fromLatLng!,
                            toLatLng: widget.cubit.toLatLng!,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.red,
                            content: Text(
                              "Error: LatLng values are null",
                              style: TextStyles.font18BlackRegular,
                            ),
                          ),
                        );
                        safePrint("Error: LatLng values are null");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.sp),
                      margin: EdgeInsets.all(1.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      width: uniqueTrips[index].to.length > 15
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        uniqueTrips[index].to,
                        style: TextStyles.font18BlackRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
