import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final void Function() navigation;
  final bool? withShadow;
  const AppIcon(
      {super.key,
      required this.icon,
      required this.backgroundColor,
      required this.iconColor,
      required this.navigation,
      this.withShadow = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10.r), boxShadow: [
        if (withShadow == true)
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
      ]),
      child: InkWell(
        onTap: navigation,
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
