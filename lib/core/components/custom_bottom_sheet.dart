import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';

import '../theming/app_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showCloseIcon;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showCloseIcon = true,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(borderRadius.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseIcon || title != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (showCloseIcon)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.semiGrey.withOpacity(0.3),
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: Colors.black,
                            size: 25.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            verticalSpacing(10),
            child,
          ],
        ),
      ),
    );
  }
}
