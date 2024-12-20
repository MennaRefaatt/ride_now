import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/styles.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(text, style: TextStyles.font24BlackBold.copyWith(
          fontSize: 20.sp,
        )),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1), child: Divider()));
  }
}
