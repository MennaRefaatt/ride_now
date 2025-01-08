import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../manager/home_cubit.dart';

class LastTripsListView extends StatefulWidget {
   LastTripsListView({super.key, required this.lastTrips, required this.disappear, required this.cubit});
  final List<TripModel> lastTrips;
   bool disappear;
  final HomeCubit cubit;

  @override
  State<LastTripsListView> createState() => _LastTripsListViewState();
}

class _LastTripsListViewState extends State<LastTripsListView> {

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.disappear,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.6,
        child: widget.lastTrips.length == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.cubit.toController.text = widget.lastTrips[0].to;
                      if (widget.cubit.toController.text ==
                          widget.lastTrips[0].to) {
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
                      width: widget.lastTrips[0].to.length > 15
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        widget.lastTrips[0].to,
                        style: TextStyles.font18BlackRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: widget.lastTrips.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    widget.cubit.toController.text = widget.lastTrips[index].to;
                    if (widget.cubit.toController.text ==
                        widget.lastTrips[index].to) {
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
                    width: widget.lastTrips[index].to.length > 15
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.25,
                    child: Text(
                      widget.lastTrips[index].to,
                      style: TextStyles.font18BlackRegular,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
