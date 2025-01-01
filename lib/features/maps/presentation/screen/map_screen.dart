import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/components/app_icon.dart';
import '../../../../core/di/di.dart';
import '../../../../core/helpers/safe_print.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/utils/app_button.dart';
import '../../../../generated/l10n.dart';
import '../manager/location_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(sl(), sl(), sl())..fetchUserLocation(),
      child: Scaffold(
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationLoaded || state is LocationMarkerSet) {
              final position = state is LocationLoaded
                  ? LatLng(state.position.latitude, state.position.longitude)
                  : (state as LocationMarkerSet).location;
              final address = state is LocationLoaded
                  ? state.address
                  : (state as LocationMarkerSet).address;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_mapController != null && position != _selectedLocation) {
                  //_animateToLocation(position);                  _selectedLocation = position;
                }
              });

              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: position,
                                zoom: 15,
                              ),
                              onMapCreated: (controller) {
                                _mapController = controller;
                                // _animateToLocation(position);
                              },
                              markers: _selectedLocation != null
                                  ? {
                                      Marker(
                                        markerId:
                                            const MarkerId('selectedLocation'),
                                        infoWindow: InfoWindow(
                                          title: address.toString(),
                                        ),
                                        position: _selectedLocation!,
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                          BitmapDescriptor.hueGreen,
                                        ),
                                      ),
                                    }
                                  : {},
                              onCameraMove: (CameraPosition position) {
                                setState(() {
                                  _selectedLocation = position.target;
                                });
                              },
                              onCameraIdle: () {
                                if (_selectedLocation != null) {
                                  context
                                      .read<LocationCubit>()
                                      .setMarker(_selectedLocation!);
                                }
                              },
                            ),
                            AppButton(
                              text: S().done,
                              backgroundColor: AppColors.primary,
                              borderRadius: 15.r,
                              onPressed: () =>
                                  Navigator.pop(context, address),
                              textStyle: TextStyles.font18BlackRegular,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.sp, vertical: 40.sp),
                    child: AppIcon(
                        icon: CupertinoIcons.back,
                        backgroundColor: Colors.white,
                        iconColor: Colors.black,
                        navigation: () => Navigator.pop(context),
                        withShadow: false),
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
                            icon: Icons.zoom_in,
                            backgroundColor: Colors.white,
                            iconColor: Colors.black,
                            navigation: _zoomIn,
                            withShadow: false,
                          ),
                          SizedBox(height: 10.sp),
                          AppIcon(
                            icon: CupertinoIcons.location,
                            backgroundColor: Colors.white,
                            iconColor: Colors.black,
                            navigation: () async {
                              final locationState =
                                  context.read<LocationCubit>().state;
                              if (locationState is LocationLoaded) {
                                final position = LatLng(
                                    locationState.position.latitude,
                                    locationState.position.longitude);
                                // _animateToLocation(position);
                              } else {
                                await context
                                    .read<LocationCubit>()
                                    .fetchUserLocation();
                              }
                            },
                            withShadow: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is LocationError) {
              return Center(child: Text(state.message));
            }
            return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 10));
          },
        ),
      ),
    );
  }

  // void _animateToLocation(LatLng position) {
  //   if (_mapController != null) {
  //     _mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: position,
  //           zoom: 18,
  //           tilt: 50,
  //           bearing: 0,
  //         ),
  //       ),
  //     );
  //
  //     _mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: position,
  //           zoom: 18,
  //         ),
  //       ),
  //     );
  //   }
  // }
  //
  void _zoomIn() {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.zoomIn(),
      );
    }
  }
}
