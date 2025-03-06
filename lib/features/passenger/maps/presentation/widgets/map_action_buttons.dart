import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/components/app_icon.dart';
import '../../../../../core/helpers/spacing.dart';
import '../manager/location_cubit.dart';

class MapActionButtons extends StatelessWidget {
  const MapActionButtons({super.key,required this.zoomIn,required this.zoomOut});
final void Function() zoomIn ;
final void Function() zoomOut ;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 15.sp, vertical: 40.sp),
            child: AppIcon(
                icon: CupertinoIcons.back,
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                navigation: () => Navigator.pop(context),
                withShadow: false),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20.sp,
                right: 20.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  icon: CupertinoIcons.zoom_in,
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  navigation: zoomIn,
                  withShadow: false,
                ),
                verticalSpacing(10),
                AppIcon(
                  icon: CupertinoIcons.zoom_out,
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  navigation: zoomOut,
                  withShadow: false,
                ),
                verticalSpacing(10.h),
                AppIcon(
                  icon: CupertinoIcons.location,
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  navigation: () =>
                      context.read<LocationCubit>().fetchUserLocation(),
                  withShadow: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
