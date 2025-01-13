import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/features/passenger/home/presentation/manager/home_cubit.dart';
import '../../../../maps/presentation/manager/location_cubit.dart';

class MapWidget extends StatefulWidget {
  MapWidget({super.key, required this.homeCubit, required this.isHidden});
  late bool isHidden;
  final HomeCubit homeCubit;
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final GoogleMapController mapController;

  void _onMapSwipe() {
    setState(() {
      widget.isHidden = true;
    });
  }

  void _onMapStop() {
    setState(() {
      widget.isHidden = false;
    });
  }

  void _updateCameraPosition(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15,
        ),
      ),
    );

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is LocationLoaded || state is LocationMarkerSet) {
          final position = state is LocationLoaded
              ? LatLng(state.position.latitude, state.position.longitude)
              : (state as LocationMarkerSet).location;
          widget.homeCubit.fromLatLng = position;
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
                  zoom: 18,
                ),
                onMapCreated: (controller) {
                  mapController = controller;
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
        return GoogleMap(
          mapType: MapType.satellite,
          initialCameraPosition:
              CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 10),
        );
      },
    );
  }
}
