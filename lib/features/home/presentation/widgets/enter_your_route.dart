import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/home/presentation/widgets/recent_ride.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';

class EnterYourRoute extends StatefulWidget {
  final FocusNode fromFocusNode;
  final FocusNode toFocusNode;
  final String fromText;
  final Color backgroundColor;

  const EnterYourRoute({
    super.key,
    required this.fromFocusNode,
    required this.toFocusNode,
    required this.fromText,
    required this.backgroundColor,
  });

  @override
  _EnterYourRouteState createState() => _EnterYourRouteState();
}

class _EnterYourRouteState extends State<EnterYourRoute> {
  late TextEditingController _fromController;
  TextEditingController toController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController(text: widget.fromText);
    toController = TextEditingController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void _clearTextField(TextEditingController controller, FocusNode focusNode) {
    controller.clear();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            controller: _fromController,
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
              visible: _fromController.text.isNotEmpty,
              child: IconButton(
                onPressed: () {
                  _clearTextField(_fromController, widget.fromFocusNode);
                },
                icon: Icon(CupertinoIcons.clear_circled,
                color: Colors.black,
                size: 25.sp,
                ),
              ),
            ),
          ),
          AppTextFormField(
            focusNode: widget.toFocusNode,
            //controller: _toController,
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
          ),
          verticalSpacing(30.h),
          InkWell(
            onTap: () => Navigator.pushNamed(context, RoutingEndpoints.maps),
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
    );
  }
}
