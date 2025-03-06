import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onTap;

  const CustomMapWidget({
    Key? key,
    required this.initialPosition,
    required this.markers,
    required this.polylines,
    this.onMapCreated,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomMapWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: 10,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        if (widget.onMapCreated != null) {
          widget.onMapCreated!(controller);
        }
      },
      onTap: widget.onTap,
      markers: widget.markers,
      polylines: widget.polylines,
    );
  }
}
