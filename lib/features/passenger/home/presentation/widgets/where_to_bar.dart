import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/services/routing/routing_endpoints.dart';
import '../../../../maps/presentation/manager/location_cubit.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../manager/home_cubit.dart';

class WhereToBar extends StatefulWidget {
  const WhereToBar({super.key, required this.cubit, required this.lastTrips});
  final HomeCubit cubit;
  final List<TripModel> lastTrips;

  @override
  State<WhereToBar> createState() => _WhereToBarState();
}

class _WhereToBarState extends State<WhereToBar> {
  bool disappear = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        String fromText = 'S().From';
        Color backgroundColor = Colors.grey.shade200;

        if (state is LocationLoaded) {
          fromText = state.address;
          backgroundColor = Colors.transparent;
          widget.cubit.fromController.text = state.address;
        }
        disappear = widget.cubit.toController.text.isNotEmpty;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                widget.cubit.openEnterYourRoute(
                    context,
                    widget.cubit.fromFocusNode,
                    widget.cubit.toFocusNode,
                    fromText,
                    backgroundColor,
                    widget.cubit);
                widget.cubit.fromFocusNode.requestFocus();
              },
              child: AppTextFormField(
                controller: TextEditingController(text: fromText),
                borderRadius: BorderRadius.circular(15.r),
                backgroundColor: backgroundColor,
                borderColor: Colors.transparent,
                isFilled: true,
                withHint: true,
                enable: false,
                hintStyle: TextStyles.font18BlackRegular.copyWith(
                  color: Colors.grey.shade800,
                ),
                hintText: "S().From",
                keyboardType: TextInputType.text,
                prefixIcon: Icon(
                  Icons.trip_origin,
                  color: AppColors.primary,
                  size: 25.sp,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.cubit.openEnterYourRoute(
                        context,
                        widget.cubit.fromFocusNode,
                        widget.cubit.toFocusNode,
                        fromText,
                        backgroundColor,
                        widget.cubit);
                    widget.cubit.toFocusNode.requestFocus();
                  },
                  child: AppTextFormField(
                    controller: widget.cubit.toController,
                    borderRadius: BorderRadius.circular(15.r),
                    backgroundColor:
                        disappear ? Colors.transparent : Colors.grey.shade200,
                    borderColor: Colors.transparent,
                    isFilled: true,
                    withHint: true,
                    enable: false,
                    hintStyle: TextStyles.font18BlackRegular.copyWith(
                      color: Colors.grey.shade800,
                    ),
                    hintText: "S().To",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: disappear ? AppColors.primary : Colors.black,
                      size: 25.sp,
                    ),
                  ),
                ),
                Visibility(
                  visible: !disappear,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView.builder(
                      itemCount: widget.lastTrips.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          widget.cubit.toController.text =
                              widget.lastTrips[index].to;
                          if (widget.cubit.toController.text ==
                              widget.lastTrips[index].to) {
                            setState(() {
                              disappear = true;
                            });
                            Navigator.pushNamed(
                                context, RoutingEndpoints.checkOut,
                                arguments: CheckOutArgs(
                                    fromAddress:
                                        widget.cubit.fromController.text,
                                    toAddress: widget.cubit.toController.text));
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
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
