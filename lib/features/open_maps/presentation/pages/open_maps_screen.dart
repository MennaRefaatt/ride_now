import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/components/app_icon.dart';
import 'package:ride_now/core/utils/app_button.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
class OpenMapsScreen extends StatelessWidget {
  const OpenMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(
            height: 500,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 14.4746,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(
                  icon: CupertinoIcons.back,
                  backgroundColor: Colors.white,
                  iconColor: Colors.black87,
                  navigation: () => Navigator.pop(context),
                  withShadow: true,
                ),
                AppIcon(
                  withShadow: true,
                  icon: Icons.more_horiz,
                  backgroundColor: Colors.white,
                  iconColor: Colors.black87,
                  navigation: () {},
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200.h,
              width: double.infinity,
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r),
                  )),
              child: Column(
                children: [
                  const Text("Ride Now"),
                  AppButton(
                    text: "S().order",
                    textStyle: TextStyles.font14BlackRegular,
                    onPressed: () {},
                    backgroundColor: AppColors.primary,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
