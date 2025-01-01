import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import '../../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';
class WhereToBar extends StatelessWidget {
  const WhereToBar({super.key, required this.cubit});
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        String fromText = 'S().From';
        Color backgroundColor = Colors.grey.shade200;

        if (state is LocationLoaded) {
          fromText = state.address;
          backgroundColor = Colors.transparent;
          cubit.fromController.text = state.address;
        }

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                cubit.openEnterYourRoute(context, cubit.fromFocusNode,
                    cubit.toFocusNode, fromText, backgroundColor, cubit);
                cubit.fromFocusNode.requestFocus();
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
                cubit.openEnterYourRoute(context, cubit.fromFocusNode,
                    cubit.toFocusNode, fromText, backgroundColor, cubit);
                cubit.toFocusNode.requestFocus();
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
