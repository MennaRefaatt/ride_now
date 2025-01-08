import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import '../core/theming/app_colors.dart';
import '../core/theming/styles.dart';

class ConnectionAwareWidget extends StatefulWidget {
  const ConnectionAwareWidget({
    super.key,
  });

  @override
  State<ConnectionAwareWidget> createState() => _ConnectionAwareWidgetState();
}

class _ConnectionAwareWidgetState extends State<ConnectionAwareWidget> {
  late StreamSubscription _subscription;
  bool _isConnectionLost = false;

  @override
  void initState() {
    super.initState();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final isLost = result == ConnectivityResult.none;
    if (isLost != _isConnectionLost) {
      setState(() {
        _isConnectionLost = isLost;
      });
      if (isLost) {
        _showSnackBar(
          "No internet connection. Please check your network.",
          isError: true,
        );
        safePrint("No internet connection. Please check your network.");
      } else {
        _showSnackBar(
          "Back online!",
          isError: false,
        );
        safePrint("Back online!");
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isConnectionLost,
      child: Container(
        width: double.infinity,
        color: AppColors.red,
        padding: EdgeInsets.all(16.sp),
        child: Text(
          "Connection is Lost",
          style: TextStyles.font18WhiteBold,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
