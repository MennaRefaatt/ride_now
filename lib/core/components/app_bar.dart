import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/styles.dart';

class DefaultAppBar extends StatelessWidget {
  DefaultAppBar({
    super.key,
    required this.text,
    this.withDivider = true,
    this.backgroundColor,
    this.leading = true,
    this.onPressed,
  });
  final String text;
  bool? withDivider;
  Color? backgroundColor;
  bool? leading;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(text,
            style: TextStyles.font24BlackBold.copyWith(
              fontSize: 20.sp,
            )),
        backgroundColor: backgroundColor,
        leading: leading == true
            ? IconButton(
                onPressed: onPressed, icon: const Icon(Icons.arrow_back_ios))
            : Container(),
        centerTitle: true,
        bottom: withDivider == true
            ? PreferredSize(
                preferredSize: const Size.fromHeight(1), child: Divider())
            : null);
  }
}
