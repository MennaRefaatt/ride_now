
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import '../helpers/safe_print.dart';
import '../theming/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: (index) {
          safePrint(index);
          if (index == 0) {
          }
          if (index == 1) {
          }
          if (index == 2) {
          }
          if (index == 3) {
          }
        },
        currentIndex: index,
        selectedLabelStyle: TextStyle(fontSize: 12.sp),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        showSelectedLabels: true,
        items:  [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.house_alt),
            label: S().home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.bag),
            label: S().orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.heart),
            label: S().favorite,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: S().settings,
          ),
        ]);
  }
}
