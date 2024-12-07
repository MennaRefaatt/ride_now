import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/core/utils/app_image.dart';
import 'package:audioplayers/audioplayers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimationRide;
  late Animation<Offset> _slideAnimationNow;
  late Animation<Offset> _carAnimation;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _slideAnimationRide = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimationNow = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _carAnimation = Tween<Offset>(begin: const Offset(1.5, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
       _opacity = 1.0;
    });

    _animationController.forward();

    await Future.delayed(const Duration(seconds: 2));
    _audioPlayer.play(AssetSource('sounds/car_horn.mp3'));
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, RoutingEndpoints.onBoardingScreen); ;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _carAnimation,
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: AppImageAsset(
                path: 'icons/app_icon.png',
                height: 300.h,
                width: 300.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: _slideAnimationRide,
                child: Text(
                  "𝚁𝚒𝚍𝚎",
                  style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.green),
                ),
              ),
              SlideTransition(
                position: _slideAnimationNow,
                child: Text(
                  "𝙽𝚘𝚠",
                  style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
