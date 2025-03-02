import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/cubits/app/app_cubit.dart';
import '../../generated/l10n.dart';
import '../helpers/shared_pref.dart';
import '../services/routing/router.dart';
import '../services/routing/routing_endpoints.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../theming/app_theme.dart';

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
        builder: (context) => BlocProvider(
              create: (context) => AppCubit(),
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  final themeMode =
                      state is AppLoaded ? state.themeMode : ThemeMode.system;
                  final locale =
                      state is AppLoaded ? state.locale : Locale('en');
                  return ScreenUtilInit(
                    designSize: const Size(390, 844),
                    minTextAdapt: true,
                    builder: (context, child) {
                      return MaterialApp(
                        navigatorKey: appNavKey,
                        onGenerateRoute: RouteServices.generateRoute,
                        title: 'ride_now',
                        theme: AppTheme.lightTheme,
                        darkTheme: AppTheme.darkTheme,
                        themeMode: themeMode,
                        supportedLocales: S.delegate.supportedLocales,
                        localizationsDelegates: [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        key: ValueKey(SharedPref.getCurrentLanguage()),
                        locale: locale,
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
