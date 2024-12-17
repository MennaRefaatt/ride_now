import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_text_form_field.dart';
import 'package:ride_now/core/theming/styles.dart';


class WhereToBar extends StatelessWidget {
  const WhereToBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(
              minWidth: double.infinity), // Add constraints
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField(
                controller: TextEditingController(),
                borderRadius: BorderRadius.circular(15.r),
                backgroundColor: Colors.grey.shade300,
                borderColor: Colors.transparent,
                isFilled: true,
                withHint: true,
                hintStyle: TextStyles.font12WhiteRegular,
                hintText: "S().From",
                keyboardType: TextInputType.text,
                prefixIcon: Icon(Icons.trip_origin, color: Colors.white),
              ),
              AppTextFormField(
                controller: TextEditingController(),
                borderRadius: BorderRadius.circular(15.r),
                backgroundColor: Colors.grey.shade300,
                borderColor: Colors.transparent,
                isFilled: true,
                hintStyle: TextStyles.font12WhiteRegular,
                withHint: true,
                hintText: "S().To",
                keyboardType: TextInputType.text,
                prefixIcon: Icon(CupertinoIcons.search, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
