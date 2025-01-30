import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/components/app_icon.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../../generated/l10n.dart';
import '../../data/model/location_model.dart';
import '../manager/location_cubit.dart';
import '../maps_args.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key,required this.mapsArgs});
 final MapsArgs mapsArgs;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  double markerTopPosition = 100.0;
  @override
  void initState() {
    super.initState();
    if (widget.mapsArgs.initialLatitude != null && widget.mapsArgs.initialLongitude != null) {
      _selectedLocation = LatLng(widget.mapsArgs.initialLatitude!, widget.mapsArgs.initialLongitude!);
    } else {
      context.read<LocationCubit>().fetchUserLocation();
    }
  }

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
                  _selectedLocation = position;
                  _selectedAddress = address;
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
                              mapType: MapType.satellite,
                              initialCameraPosition: CameraPosition(
                                target: _selectedLocation ??position,
                                zoom: 15,
                              ),
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              zoomControlsEnabled: false,
                              markers: _selectedLocation != null
                                  ? {
                                      Marker(
                                        markerId:
                                            const MarkerId('selectedLocation'),
                                        infoWindow: InfoWindow(
                                          title:_selectedAddress ?? address.toString(),
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
                            if (_selectedLocation != null)
                              Positioned(
                                top: markerTopPosition,
                                left: MediaQuery.of(context).size.width * 0.25,
                                child: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    padding: EdgeInsets.all(8.sp),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: AppColors.primary,
                                    ),
                                    child: Text(
                                      address.toString(),
                                      style: TextStyles.font18WhiteRegular,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            AppButton(
                              text: S().done,
                              backgroundColor: AppColors.primary,
                              borderRadius: 15.r,
                              onPressed: () {
                                if (_selectedLocation != null) {
                                  Navigator.pop(
                                    context,
                                    LocationData(
                                      address: _selectedAddress!,
                                      latitude: _selectedLocation!.latitude,
                                      longitude: _selectedLocation!.longitude,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: AppColors.red,
                                        content:
                                            Text("Please select a location.")),
                                  );
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppIcon(
                            icon: CupertinoIcons.zoom_in,
                            backgroundColor: Colors.white,
                            iconColor: Colors.black,
                            navigation: _zoomIn,
                            withShadow: false,
                          ),
                          verticalSpacing(10.h),
                          AppIcon(
                            icon: CupertinoIcons.zoom_out,
                            backgroundColor: Colors.white,
                            iconColor: Colors.black,
                            navigation: _zoomOut,
                            withShadow: false,
                          ),
                          verticalSpacing(10.h),
                          AppIcon(
                            icon: CupertinoIcons.location,
                            backgroundColor: Colors.white,
                            iconColor: Colors.black,
                            navigation: () => context
                                .read<LocationCubit>()
                                .fetchUserLocation(),
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

  void _zoomIn() {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.zoomIn(),
      );
    }
  }

  void _zoomOut() {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.zoomOut(),
      );
    }
  }
}
