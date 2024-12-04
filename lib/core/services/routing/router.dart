import 'package:flutter/material.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/auth/login/presentation/pages/login_screen.dart';
import 'package:ride_now/features/auth/register/presentation/pages/register_screen.dart';
import 'package:ride_now/features/home/presentation/pages/home_screen.dart';
import 'package:ride_now/features/on_boarding_screen.dart';
import 'package:ride_now/features/open_maps/presentation/pages/open_maps_screen.dart';
import 'package:ride_now/features/scanner.dart';
import 'package:ride_now/features/splash.dart';
import 'package:ride_now/features/where_to/presentation/pages/where_to_screen.dart';

import '../../helpers/safe_print.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    safePrint('generateRoute => ${routeSettings.name}');
    safePrint('generateRoute => ${routeSettings.arguments}');

    switch (routeSettings.name) {
      case RoutingEndpoints.splash:
        return _customFadeRoute(const SplashScreen(), routeSettings.name!);
      case RoutingEndpoints.onBoardingScreen:
        return _customFadeRoute(
            const OnBoardingScreen(), routeSettings.name!);
      case RoutingEndpoints.scanner:
        return _customFadeRoute(
            const LicensePlateScanner(), routeSettings.name!);
      case RoutingEndpoints.login:
        return _customFadeRoute(const LoginScreen(), routeSettings.name!);
      case RoutingEndpoints.register:
        return _customFadeRoute(const RegisterScreen(), routeSettings.name!);
      case RoutingEndpoints.home:
        return _customFadeRoute(const HomeScreen(), routeSettings.name!);
      case RoutingEndpoints.whereTo:
        return _customFadeRoute(const WhereToScreen(), routeSettings.name!);
        case RoutingEndpoints.openMaps:
        return _customFadeRoute(const OpenMapsScreen(), routeSettings.name!);
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
      transitionDuration: const Duration(milliseconds: 500), // Customize duration
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
