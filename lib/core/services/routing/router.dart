import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/auth/login/presentation/pages/login_screen.dart';
import 'package:ride_now/features/auth/login/presentation/pages/otp_screen.dart';
import 'package:ride_now/features/check_out/presentation/pages/check_out.dart';
import 'package:ride_now/features/home/presentation/pages/home_screen.dart';
import 'package:ride_now/features/maps/presentation/screen/map_screen.dart';
import 'package:ride_now/features/on_boarding_screen.dart';
import 'package:ride_now/features/profile/presentation/pages/city_screen.dart';
import 'package:ride_now/features/profile/presentation/pages/profile_screen.dart';
import 'package:ride_now/features/scanner.dart';
import 'package:ride_now/features/settings/presentation/pages/settings_screen.dart';
import 'package:ride_now/features/splash.dart';
import '../../helpers/safe_print.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    safePrint('generateRoute => ${routeSettings.name}');
    safePrint('generateRoute => ${routeSettings.arguments}');

    switch (routeSettings.name) {
      case RoutingEndpoints.splash:
        return _customFadeRoute(const SplashScreen(), routeSettings.name!);
      case RoutingEndpoints.onBoardingScreen:
        return _customFadeRoute(const OnBoardingScreen(), routeSettings.name!);
      case RoutingEndpoints.scanner:
        return _customFadeRoute(
            const LicensePlateScanner(), routeSettings.name!);
      case RoutingEndpoints.login:
        return _customFadeRoute(ProviderScope(child: const LoginScreen()), routeSettings.name!);
      case RoutingEndpoints.home:
        return _customFadeRoute(const HomeScreen(), routeSettings.name!);
        case RoutingEndpoints.city:
        return _customFadeRoute(const CityScreen(), routeSettings.name!);
      case RoutingEndpoints.settings:
        return _customFadeRoute(const SettingsScreen(), routeSettings.name!);
        case RoutingEndpoints.maps:
        return _customFadeRoute(const MapScreen(), routeSettings.name!);
        case RoutingEndpoints.checkOut:
        return _customFadeRoute(const CheckOut(), routeSettings.name!);
        case RoutingEndpoints.profile:
        return _customFadeRoute( ProfileScreen(), routeSettings.name!);
      case RoutingEndpoints.otp:
        return _customFadeRoute(
            OTPScreen(verificationId: routeSettings.arguments as String), routeSettings.name!);
       default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _customFadeRoute(Widget screen, String routeName) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 500), // Customize duration
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
