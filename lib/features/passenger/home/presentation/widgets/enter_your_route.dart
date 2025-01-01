import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/passenger/home/presentation/manager/home_cubit.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/recent_ride.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../check_out/presentation/check_out_args.dart';

class EnterYourRoute extends StatefulWidget {
  final FocusNode fromFocusNode;
  final FocusNode toFocusNode;
  final String fromText;
  final Color backgroundColor;
  final HomeCubit cubit;

  const EnterYourRoute({
    super.key,
    required this.fromFocusNode,
    required this.toFocusNode,
    required this.fromText,
    required this.backgroundColor,
    required this.cubit,
  });

  @override
  State<EnterYourRoute> createState() => _EnterYourRouteState();
}

class _EnterYourRouteState extends State<EnterYourRoute> {
  @override
  void initState() {
    super.initState();
    widget.cubit.fromController = TextEditingController(text: widget.fromText);
    widget.cubit.toController = TextEditingController();
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

  @override
  void dispose() {
    widget.cubit.fromController.dispose();
    widget.cubit.toController.dispose();
    super.dispose();
  }

  void _clearTextField(TextEditingController controller, FocusNode focusNode) {
    controller.clear();
    focusNode.requestFocus();
  }

  void _navigateToCheckout(BuildContext context) {
    final fromAddress = widget.cubit.fromController.text.trim();
    final toAddress = widget.cubit.toController.text.trim();

    if (fromAddress.isEmpty || toAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Both 'From' and 'To' fields are required!")),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      RoutingEndpoints.checkOut,
      arguments: CheckOutArgs(
        fromAddress: fromAddress,
        toAddress: toAddress,
      ),
    );
  }

  void _navigateToMaps(BuildContext context, TextEditingController controller) {
    Navigator.pushNamed(
      context,
      RoutingEndpoints.maps,
    ).then((result) {
      if (result != null && result is String) {
        setState(() {
          controller.text = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15.sp),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "S().Enter your route",
                    style: TextStyles.font24BlackBold,
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
              hintText: "S().From",
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
              hintText: "S().To",
              keyboardType: TextInputType.text,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.black,
                size: 25.sp,
              ),
              onFieldSubmitted: (_) => _navigateToCheckout(context),
            ),
            verticalSpacing(30.h),
            InkWell(
              onTap: () => _navigateToMaps(context, widget.cubit.toController),
              borderRadius: BorderRadius.circular(15.r),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  Icon(CupertinoIcons.map_pin_ellipse,
                      color: AppColors.primary, size: 30.sp),
                  horizontalSpacing(10.w),
                  Text(
                    "S().Choose on map",
                    style: TextStyles.font18WhiteBold
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            verticalSpacing(10.h),
            RecentRide(),
          ],
        ),
      ),
    );
  }
}
