import 'package:flutter/material.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/auth/login/presentation/pages/login_screen.dart';
import 'package:ride_now/features/auth/register/presentation/pages/register_screen.dart';
import 'package:ride_now/features/on_boarding_screen.dart';
import 'package:ride_now/features/scanner.dart';
import 'package:ride_now/features/splash.dart';

import '../../helpers/safe_print.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    safePrint('generateRoute => ${routeSettings.name}');
    safePrint('generateRoute => ${routeSettings.arguments}');
    switch (routeSettings.name) {
      case RoutingEndpoints.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        case RoutingEndpoints.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case RoutingEndpoints.scanner:
        return MaterialPageRoute(builder: (_) => const LicensePlateScanner());
      case RoutingEndpoints.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RoutingEndpoints.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      default:
        return _errorRoute();
    }
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
