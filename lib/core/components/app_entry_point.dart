import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/features/notifications/presentation/manager/notification_cubit.dart';

import '../../generated/l10n.dart';
import '../cubits/language/language_cubit.dart';
import '../di/di.dart';
import '../helpers/shared_pref.dart';
import '../services/routing/router.dart';
import '../services/routing/routing_endpoints.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final appNavKey = GlobalKey<NavigatorState>();

class AppEntryPoint extends StatefulWidget {
  final String initialRoute;

  const AppEntryPoint({
    super.key,
    required this.initialRoute,
  });

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
        builder: (context) =>
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LanguageCubit(),
                ),
                BlocProvider(
                  create: (context) =>NotificationsCubit(sl()),
                ),
              ],
              child: BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  return ScreenUtilInit(
                    designSize: const Size(390, 844),
                    minTextAdapt: true,
                    builder: (context, child) {
                      return MaterialApp(
                        navigatorKey: appNavKey,
                        onGenerateRoute: RouteServices.generateRoute,
                        title: 'ride_now',
                        supportedLocales: S.delegate.supportedLocales,
                        localizationsDelegates: [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        key: ValueKey(SharedPref.getCurrentLanguage()),
                        locale: Locale(SharedPref.getCurrentLanguage()),
                        debugShowCheckedModeBanner: false,
                        builder: EasyLoading.init(),
                        initialRoute: widget.initialRoute.isNotEmpty
                            ? widget.initialRoute
                            : RoutingEndpoints.splash,
                      );
                    },
                  );
                },
              ),
            ));
  }
}
