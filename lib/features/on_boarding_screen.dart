import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/components/app_name.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import '../core/helpers/enums/user_type.dart';
import '../core/helpers/shared_pref_keys.dart';
import '../core/services/routing/routing_endpoints.dart';
import '../core/theming/styles.dart';
import '../core/utils/app_image.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    Future.microtask(_checkFirstLaunch);
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(_animationController);
  }

  Future<void> _checkFirstLaunch() async {
    bool isFirstOpen = await SharedPref.isFirstOpen();
    if (isFirstOpen) {
      await SharedPref.setFirstOpen(false);
      return;
    }

    final userType = SharedPref.getString(key: MySharedKeys.type);
    final userId = SharedPref.getString(key: MySharedKeys.userId);

    if (userId == null) {
      _navigateTo(RoutingEndpoints.login);
    } else if (userType == UserType.driver.name) {
      _navigateTo(RoutingEndpoints.driverHome);
    } else {
      _navigateTo(RoutingEndpoints.passengerHome);
    }
  }

  void _navigateTo(String route) {
    if (mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppImageAsset(
            path: "images/green_car.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(30.h),
                const AppName(),
                verticalSpacing(50.h),
                const _TitleText(),
                verticalSpacing(30.h),
                const _SubtitleText(),
              ],
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: _GetStartedButton(alignmentAnimation: _alignmentAnimation),
          ),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text("Taxi of your\ndreams", style: TextStyles.font34WhiteMedium);
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Ride now your taxi and ride with ease",
      style: TextStyles.font14WhiteRegular.copyWith(fontSize: 20),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final Animation<Alignment> alignmentAnimation;

  const _GetStartedButton({required this.alignmentAnimation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(
          context,
          RoutingEndpoints.login,
        ),
        child: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              horizontalSpacing(10.w),
              Text("S().Get Started", style: TextStyles.font18BlackRegular),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CircleAvatar(
                  backgroundColor: AppColors.black,
                  child: AnimatedBuilder(
                    animation: alignmentAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: alignmentAnimation.value,
                        child: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
