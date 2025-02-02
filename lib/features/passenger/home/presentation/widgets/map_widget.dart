import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/core/theming/styles.dart';
import 'package:ride_now/features/passenger/home/presentation/manager/home_cubit.dart';
import '../../../maps/presentation/manager/location_cubit.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {super.key,
      required this.homeCubit,
      required this.isHidden,
      required this.updateHiddenState});
  final bool isHidden;
  final HomeCubit homeCubit;
  final Function(bool) updateHiddenState;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final GoogleMapController mapController;
  LatLng? selectedLocation;

  void _onMapSwipe() {
    widget.updateHiddenState(true);
  }

  void _onMapStop() {
    widget.updateHiddenState(false);
  }

  void _updateCameraPosition(LatLng position) {
    if (mapController != null) {
      final cameraPosition = CameraPosition(
        target: position,
        zoom: 18,
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LocationCubit, LocationState, Map<String, dynamic>?>(
      selector: (state) {
        if (state is LocationLoaded) {
          return {
            'position':
                LatLng(state.position.latitude, state.position.longitude),
            'address': state.address,
          };
        } else if (state is LocationMarkerSet) {
          return {
            'position': state.location,
            'address': state.address,
          };
        }
        return null;
      },
      builder: (context, data) {
        if (data == null) {
          return GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357),
              zoom: 10,
            ),
          );
        }

        final position = data['position']!;
        final address = data['address']!;

        widget.homeCubit.fromLatLng = position;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mapController != null && selectedLocation != null) {
            _updateCameraPosition(selectedLocation!);
          }
        });

        selectedLocation = position;

        return GestureDetector(
          onPanUpdate: (details) => _onMapSwipe(),
          onPanEnd: (_) => _onMapStop(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: position,
                    zoom: 18,
                  ),
                  onMapCreated: (controller) => mapController = controller,
                  markers: {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      infoWindow: InfoWindow(title: address),
                      position: position,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      ),
                    ),
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _updateCameraPosition(cameraPosition.target);
                  },
                  onTap: (LatLng tappedLocation) {
                    context.read<LocationCubit>().setMarker(tappedLocation);
                  },
                ),
                if (selectedLocation != null)
                  Positioned(
                    top: 100,
                    left: MediaQuery.of(context).size.width * 0.25,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.primary,
                        ),
                        child: Text(
                          address,
                          style: TextStyles.font18WhiteRegular,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
