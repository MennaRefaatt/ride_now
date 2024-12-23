import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/components/app_icon.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
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
            if (state is LocationLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.primary,
              ));
            } else if (state is LocationLoaded || state is LocationMarkerSet) {
              final position = state is LocationLoaded
                  ? LatLng(state.position.latitude, state.position.longitude)
                  : (state as LocationMarkerSet).location;
              final address = state is LocationLoaded
                  ? state.address
                  : (state as LocationMarkerSet).location;
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
                                zoom: 14,
                              ),
                              onMapCreated: (controller) {
                                _mapController = controller;
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
                              onPressed: () {
                                if (_selectedLocation != null) {
                                  safePrint(
                                      "Saved Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}");
                                  Navigator.pushReplacementNamed(
                                      context, RoutingEndpoints.checkOut,
                                      arguments: _selectedLocation);
                                }
                              },
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
                      child: AppIcon(
                          icon: CupertinoIcons.location,
                          backgroundColor: Colors.white,
                          iconColor: Colors.black,
                          navigation: () =>
                              context.read<LocationCubit>().fetchUserLocation(),
                          withShadow: false),
                    ),
                  ),
                ],
              );
            } else if (state is LocationError) {
              return Center(child: Text(state.message));
            }
            return const Center(
                child: Text("Press the button to get location"));
          },
        ),
      ),
    );
  }
}
