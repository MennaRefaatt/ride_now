import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/routing/router.dart';

final appNavKey = GlobalKey<NavigatorState>();

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({
    super.key,
  });

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            navigatorKey: appNavKey,
            onGenerateRoute: RouteServices.generateRoute,
            title: 'ride_now',
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              child ??= const SizedBox.shrink();
              return EasyLoading.init()(context, child);
            },
          );
        },
      ),
    );
  }
}
