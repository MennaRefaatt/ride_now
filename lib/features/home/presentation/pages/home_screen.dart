import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/home/presentation/widgets/where_to_bar.dart';
import '../../../../core/components/app_icon.dart';
import '../../../../core/di/di.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/app_button.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../../../../core/components/drawer_items.dart';
import '../widgets/ride_categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isHidden = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController _mapController;

  void _onMapSwipe() {
    setState(() {
      _isHidden = true;
    });
  }

  void _onMapStop() {
    setState(() {
      _isHidden = false;
    });
  }

  void _updateCameraPosition(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(sl(), sl(), sl())..fetchUserLocation(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerItems(),
        body: Stack(
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state is LocationLoaded || state is LocationMarkerSet) {
                  final position = state is LocationLoaded
                      ? LatLng(state.position.latitude, state.position.longitude)
                      : (state as LocationMarkerSet).location;
                  final address = state is LocationLoaded
                      ? state.address
                      : (state as LocationMarkerSet).location;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateCameraPosition(position);
                  });

                  return GestureDetector(
                    onPanUpdate: (details) {
                      if (details.delta.dy < 0 || details.delta.dx != 0) {
                        _onMapSwipe();
                      }
                    },
                    onPanEnd: (_) {
                      _onMapStop();
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: position,
                          zoom: 14,
                        ),
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('selectedLocation'),
                            infoWindow: InfoWindow(title: address.toString()),
                            position: position,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen,
                            ),
                          ),
                        },
                        onTap: (LatLng tappedLocation) {
                          context.read<LocationCubit>().setMarker(tappedLocation);
                        },
                      ),
                    ),
                  );
                }
                return const SafeArea(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: _isHidden ? -100.w : 20.w,
              top: 40.h,
              curve: Curves.easeOut,
              child: AppIcon(
                withShadow: true,
                icon: Icons.more_horiz,
                backgroundColor: Colors.white,
                iconColor: Colors.black87,
                navigation: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  0,
                  _isHidden ? 300.h : 0,
                  0,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(15.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RideCategories(),
                    WhereToBar(),
                    AppButton(
                      text: "S().Order",
                      textStyle: TextStyles.font14BlackRegular,
                      onPressed: () {
                        safePrint("Order button pressed");
                      },
                      backgroundColor: AppColors.primary,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
