import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/home/presentation/widgets/enter_your_route.dart';

import '../../../maps/presentation/manager/location_cubit.dart';

class WhereToBar extends StatelessWidget {
  const WhereToBar({super.key});

  void _openEnterYourRoute(BuildContext context, FocusNode fromFocusNode,
      FocusNode toFocusNode, String fromText, Color backgroundColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return EnterYourRoute(
          fromFocusNode: fromFocusNode,
          toFocusNode: toFocusNode,
          fromText: fromText,
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fromFocusNode = FocusNode();
    final toFocusNode = FocusNode();

    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        String fromText = 'S().From';
        Color backgroundColor = Colors.grey.shade200;

        if (state is LocationLoaded) {
          fromText = state.address;
          backgroundColor = Colors.transparent;
        }

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                _openEnterYourRoute(context, fromFocusNode, toFocusNode,
                    fromText, backgroundColor);
                fromFocusNode.requestFocus();
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
            GestureDetector(
              onTap: () {
                _openEnterYourRoute(context, fromFocusNode, toFocusNode,
                    fromText, backgroundColor);
                toFocusNode.requestFocus();
              },
              child: AppTextFormField(
                controller: TextEditingController(),
                borderRadius: BorderRadius.circular(15.r),
                backgroundColor: Colors.grey.shade200,
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
                  color: Colors.black,
                  size: 25.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
