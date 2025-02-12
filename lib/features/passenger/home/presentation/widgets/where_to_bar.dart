import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/last_trips_list_view.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../../../generated/l10n.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';

class WhereToBar extends StatefulWidget {
  WhereToBar({
    super.key,
    required this.cubit,
    required this.lastTrips,
    required this.toLatLng,
  });

  final HomeCubit cubit;
  final List<TripModel> lastTrips;
  LatLng? toLatLng;

  @override
  State<WhereToBar> createState() => _WhereToBarState();
}

class _WhereToBarState extends State<WhereToBar> {
  bool disappear = false;
  late TextEditingController fromController;

  @override
  void initState() {
    super.initState();
    fromController = widget.cubit.fromController;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.cubit.fromController.value = TextEditingValue(
                text: state.address,
                selection:
                    TextSelection.collapsed(offset: state.address.length),
              );
              widget.toLatLng =
                  LatLng(state.position.latitude, state.position.longitude);
            }
          });
        }
      },
      builder: (context, state) {
        String fromText = widget.cubit.fromController.text.isNotEmpty
            ? widget.cubit.fromController.text
            : 'Select a location';
        Color backgroundColor = widget.cubit.fromController.text.isNotEmpty
            ? Colors.transparent
            : Colors.grey.shade200;

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
                  widget.cubit,
                  widget.lastTrips,
                );
                widget.cubit.fromFocusNode.requestFocus();
              },
              child: AppTextFormField(
                controller: fromController,
                borderRadius: BorderRadius.circular(15.r),
                backgroundColor: backgroundColor,
                borderColor: Colors.transparent,
                isFilled: true,
                withHint: true,
                enable: false,
                hintStyle: TextStyles.font18BlackRegular.copyWith(
                  color: Colors.grey.shade800,
                ),
                hintText: S().fromWhere,
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
                      widget.cubit,
                      widget.lastTrips,
                    );
                    widget.cubit.toFocusNode.requestFocus();
                  },
                  child: AppTextFormField(
                    controller: widget.cubit.toController,
                    borderRadius: BorderRadius.circular(15.r),
                    backgroundColor:
                        disappear ? backgroundColor : Colors.grey.shade200,
                    borderColor: Colors.transparent,
                    isFilled: true,
                    withHint: true,
                    enable: false,
                    hintStyle: TextStyles.font18BlackRegular.copyWith(
                      color: Colors.grey.shade800,
                    ),
                    hintText: S().whereTo,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icon(
                      disappear ? Icons.trip_origin : CupertinoIcons.search,
                      color: disappear ? AppColors.red : Colors.black,
                      size: 25.sp,
                    ),
                  ),
                ),
                Directionality(
                  textDirection: Localizations.localeOf(context).languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: LastTripsListView(
                    lastTrips: widget.lastTrips,
                    cubit: widget.cubit,
                    disappear: disappear,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
