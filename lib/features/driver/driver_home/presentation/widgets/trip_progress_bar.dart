import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theming/app_colors.dart';

class TripProgressBar extends StatefulWidget {
  final VoidCallback onTimerEnd;

  const TripProgressBar({super.key, required this.onTimerEnd});

  @override
  State<TripProgressBar> createState() => _TripProgressBarState();
}

class _TripProgressBarState extends State<TripProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..forward().whenComplete(widget.onTimerEnd);

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding:  EdgeInsets.all(4.sp),
          child: LinearProgressIndicator(
            value: _animation.value,
            backgroundColor: Colors.grey.shade400,
            color: AppColors.primary,
            minHeight: 7,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
        );
      },
    );
  }
}
