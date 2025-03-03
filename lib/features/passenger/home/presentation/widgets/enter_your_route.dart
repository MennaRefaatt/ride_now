import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/passenger/home/presentation/manager/home_cubit.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/recent_ride.dart';
import 'package:ride_now/features/passenger/maps/presentation/maps_args.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../check_out/presentation/check_out_args.dart';
import '../../../maps/data/model/location_model.dart';

class EnterYourRoute extends StatefulWidget {
  final FocusNode fromFocusNode;
  final FocusNode toFocusNode;
  final String fromText;
  final Color backgroundColor;
  final HomeCubit cubit;
  final List<TripModel> trips;
  const EnterYourRoute({
    super.key,
    required this.fromFocusNode,
    required this.toFocusNode,
    required this.fromText,
    required this.backgroundColor,
    required this.cubit,
    required this.trips,
  });

  @override
  State<EnterYourRoute> createState() => _EnterYourRouteState();
}

class _EnterYourRouteState extends State<EnterYourRoute> {
  late String toAddress;
  String? errorText;
  @override
  void initState() {
    super.initState();
    widget.cubit.fromController.text = widget.fromText;
    widget.cubit.toController.text = widget.cubit.toController.text.isEmpty
        ? ""
        : widget.cubit.toController.text;

    if (widget.cubit.toController.text.isEmpty) {
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(widget.toFocusNode);
      });
    }
    if (widget.cubit.fromController.text.isEmpty) {
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(widget.fromFocusNode);
      });
    }
  }

  void _clearTextField(TextEditingController controller, FocusNode focusNode) {
    controller.clear();
    focusNode.requestFocus();
  }

  void _onAddressSelected(String address, LatLng latLng) {
    setState(() {
      widget.cubit.toController.text = address;
      widget.cubit.toLatLng = latLng;
      safePrint('Address selected: $address');
      safePrint('LatLng selected: $latLng');
    });
  }

  void _navigateToCheckout(BuildContext context) {
    final fromAddress = widget.cubit.fromController.text.trim();
    var toAddress = widget.cubit.toController.text.trim();

    if (fromAddress.isEmpty || toAddress.isEmpty) {
      errorText = "Both 'From Where?' and 'Where To?' fields are required!";
      return;
    }
    Navigator.pushNamed(
      context,
      RoutingEndpoints.checkOut,
      arguments: CheckOutArgs(
        fromAddress: fromAddress,
        toAddress: toAddress,
        fromLatLng: widget.cubit.fromLatLng!,
        toLatLng: widget.cubit.toLatLng!,
        selectedCategory:widget.cubit.selectedCategory!,
      ),
    ).then((result) {
      if (result != null && result is String) {
        setState(() {
          this.toAddress = result;
          widget.cubit.toController.text = result;
        });
      }
    });
  }

  void _navigateToMaps(
    BuildContext context,
    TextEditingController controller,
  ) {
    Navigator.pushNamed(context, RoutingEndpoints.maps,
        arguments: MapsArgs(
          initialLatitude: widget.cubit.toLatLng?.latitude,
          initialLongitude: widget.cubit.toLatLng?.longitude,
        )).then((result) {
      if (result != null && result is LocationData) {
        setState(() {
          controller.text = result.address;
          widget.cubit.toLatLng = LatLng(result.latitude, result.longitude);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(15.sp),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    S().enterYourRoute,
                    style: theme.brightness == Brightness.dark ? TextStyles.font24WhiteBold : TextStyles.font24BlackBold,
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(CupertinoIcons.xmark),
                  ),
                ),
              ],
            ),
            verticalSpacing(30.h),
            AppTextFormField(
              focusNode: widget.fromFocusNode,
              controller: widget.cubit.fromController,
              borderRadius: BorderRadius.circular(15.r),
              backgroundColor: widget.backgroundColor,
              borderColor: Colors.transparent,
              isFilled: true,
              withHint: true,
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
              suffixIcon: Visibility(
                visible: widget.cubit.fromController.text.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    _clearTextField(
                        widget.cubit.fromController, widget.fromFocusNode);
                  },
                  icon: Icon(
                    CupertinoIcons.clear_circled,
                    color: Colors.black,
                    size: 25.sp,
                  ),
                ),
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(widget.toFocusNode);
              },
            ),
            AppTextFormField(
              focusNode: widget.toFocusNode,
              controller: widget.cubit.toController,
              borderRadius: BorderRadius.circular(15.r),
              backgroundColor: Colors.grey.shade200,
              borderColor: Colors.transparent,
              isFilled: true,
              withHint: true,
              hintStyle: TextStyles.font18BlackRegular.copyWith(
                color: Colors.grey.shade800,
              ),
              hintText: S().whereTo,
              keyboardType: TextInputType.text,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.black,
                size: 25.sp,
              ),
              onFieldSubmitted: (_) => _navigateToCheckout(context),
            ),
            Visibility(
              visible: errorText != null,
              child: Text(
                errorText ?? "",
                style:
                    TextStyles.font18BlackBold.copyWith(color: AppColors.red),
              ),
            ),
            verticalSpacing(30),
            InkWell(
              onTap: () => _navigateToMaps(context, widget.cubit.toController),
              borderRadius: BorderRadius.circular(15.r),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Icon(CupertinoIcons.map_pin_ellipse,
                      color: AppColors.primary, size: 30.sp),
                  horizontalSpacing(10),
                  Text(
                    S().chooseOnMap,
                    style: TextStyles.font18WhiteBold
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            verticalSpacing(10.h),
            RecentRide(
              trips: widget.trips,
              onAddressSelected: _onAddressSelected,
            ),
          ],
        ),
      ),
    );
  }
}
