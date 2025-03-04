import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/auth/login/presentation/pages/login_screen.dart';
import 'package:ride_now/features/auth/login/presentation/pages/otp_screen.dart';
import 'package:ride_now/features/auth/phone_args.dart';
import 'package:ride_now/features/auth/phone_number_screen.dart';
import 'package:ride_now/features/contact/audio/audio_call_screen.dart';
import 'package:ride_now/features/contact/presentation/contact_args.dart';
import 'package:ride_now/features/contact/presentation/screen/contact_screen.dart';
import 'package:ride_now/features/driver/d_pending/d_pending_screen.dart';
import 'package:ride_now/features/driver/driver_home/presentation/pages/driver_home.dart';
import 'package:ride_now/features/driver/driver_not_eligible_screen/driver_not_eligible_screen.dart';
import 'package:ride_now/features/driver/driver_on_boarding/driver_on_boarding.dart';
import 'package:ride_now/features/driver/driver_registration/presentation/pages/driver_registration.dart';
import 'package:ride_now/features/notifications/presentation/manager/notification_cubit.dart';
import 'package:ride_now/features/notifications/presentation/pages/notification_screen.dart';
import 'package:ride_now/features/on_boarding_screen.dart';
import 'package:ride_now/features/passenger/maps/presentation/maps_args.dart';
import 'package:ride_now/features/privacy_policy/presentation/pages/privacy_policy_screen.dart';
import 'package:ride_now/features/profile/presentation/pages/city_screen.dart';
import 'package:ride_now/features/profile/presentation/pages/profile_screen.dart';
import 'package:ride_now/features/settings/presentation/pages/settings_screen.dart';
import 'package:ride_now/features/splash.dart';
import 'package:ride_now/features/trip_module/my_trips/my_trips_screen.dart';
import 'package:ride_now/features/wallet/presentation/pages/wallet_screen.dart';
import '../../../features/passenger/check_out/presentation/check_out_args.dart';
import '../../../features/passenger/check_out/presentation/pages/check_out.dart';
import '../../../features/passenger/home/presentation/pages/passenger_home.dart';
import '../../../features/passenger/maps/presentation/screen/map_screen.dart';
import '../../../features/trip_module/trip/presentation/pages/trip_screen.dart';
import '../../../features/trip_module/trip/presentation/trip_tracking_route_args.dart';
import '../../di/di.dart';
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
      case RoutingEndpoints.phoneNumber:
        final args = routeSettings.arguments as PhoneArgs;
        return _customFadeRoute(
            PhoneNumberScreen(args: args), routeSettings.name!);
      case RoutingEndpoints.login:
        return _customFadeRoute(
            ProviderScope(child: const LoginScreen()), routeSettings.name!);
      case RoutingEndpoints.passengerHome:
        return _customFadeRoute(const PassengerHome(), routeSettings.name!);
      case RoutingEndpoints.driverHome:
        return _customFadeRoute(const DriverHome(), routeSettings.name!);
      case RoutingEndpoints.city:
        return _customFadeRoute(const CityScreen(), routeSettings.name!);
      case RoutingEndpoints.settings:
        return _customFadeRoute(const SettingsScreen(), routeSettings.name!);
      case RoutingEndpoints.driverPendingScreen:
        return _customFadeRoute(const DPendingScreen(), routeSettings.name!);
      case RoutingEndpoints.driverNotEligibleScreen:
        return _customFadeRoute(
            const DriverNotEligibleScreen(), routeSettings.name!);
      case RoutingEndpoints.maps:
        final args = routeSettings.arguments as MapsArgs;
        return _customFadeRoute(
            MapScreen(
              mapsArgs: args,
            ),
            routeSettings.name!);
      case RoutingEndpoints.tripTracking:
        final args = routeSettings.arguments as TripTrackingRouteArgs;
        return _customFadeRoute(
            TripScreen(
              args: args,
            ),
            routeSettings.name!);
      case RoutingEndpoints.checkOut:
        final args = routeSettings.arguments as CheckOutArgs;
        return _customFadeRoute(CheckOut(args: args), routeSettings.name!);
      case RoutingEndpoints.profile:
        return _customFadeRoute(ProfileScreen(), routeSettings.name!);
      case RoutingEndpoints.driverOnBoarding:
        return _customFadeRoute(DriverOnBoarding(), routeSettings.name!);
      case RoutingEndpoints.driverRegistration:
        return _customFadeRoute(DriverRegistration(), routeSettings.name!);
      case RoutingEndpoints.contactScreen:
        return _customFadeRoute(
            ContactScreen(
              contactArgs: routeSettings.arguments as ContactArgs,
            ),
            routeSettings.name!);
      case RoutingEndpoints.audioCall:
        return _customFadeRoute(AudioCallScreen(), routeSettings.name!);
      case RoutingEndpoints.walletScreen:
        return _customFadeRoute(
            WalletScreen(userId: routeSettings.arguments as String),
            routeSettings.name!);
      case RoutingEndpoints.privacyScreen:
        return _customFadeRoute(PrivacyPolicyScreen(), routeSettings.name!);
      case RoutingEndpoints.myTripsScreen:
        return _customFadeRoute(MyTripsScreen(), routeSettings.name!);
      case RoutingEndpoints.notifications:
        return _customFadeRoute(BlocProvider(
          create: (context) => NotificationsCubit(sl()),
          child: NotificationsScreen(),
        ), routeSettings.name!);
      case RoutingEndpoints.otp:
        return _customFadeRoute(
            OTPScreen(verificationId: routeSettings.arguments as String),
            routeSettings.name!);
      default:
        safePrint('No route found for ${routeSettings.name}');
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
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
        body: Center(child: Text('Route not found')),
      );
    });
  }
}
