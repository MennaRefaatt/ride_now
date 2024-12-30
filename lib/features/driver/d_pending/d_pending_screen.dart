import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/utils/app_button.dart';
import 'package:flutter/animation.dart'; // Import for animation

import '../../../core/helpers/spacing.dart';
import '../../../core/services/routing/routing_endpoints.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/styles.dart';
import '../../../generated/l10n.dart';

class DPendingScreen extends StatefulWidget {
  const DPendingScreen({super.key});

  @override
  _DPendingScreenState createState() => _DPendingScreenState();
}

class _DPendingScreenState extends State<DPendingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale:
                        1 + _animation.value * 0.2, // Scale effect to animate
                    child: Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: AppColors.primary,
                      size: 150.sp,
                    ),
                  );
                },
              ),
              verticalSpacing(20.h),
              Text("S().Your request has been sent successfully",
                  style: TextStyles.font24BlackBold),
              verticalSpacing(10.h),
              Text("S().We will contact you soon",
                  style: TextStyles.font18BlackRegular),
              verticalSpacing(20.h),
              AppButton(
                text: S().done,
                backgroundColor: AppColors.primary,
                borderRadius: 10.r,
                onPressed: () => Navigator.pushReplacementNamed(
                    context, RoutingEndpoints.driverOnBoarding),
                textStyle: TextStyles.font18BlackRegular,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
