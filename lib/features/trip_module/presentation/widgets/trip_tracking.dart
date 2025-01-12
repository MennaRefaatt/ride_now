import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/features/maps/presentation/manager/location_cubit.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import '../../../../core/helpers/enums/trip_status.dart';
import '../../data/data_sources/direction_service/direction_service.dart';

class TripTracking extends StatefulWidget {
  const TripTracking({super.key, required this.args});
  final TripTrackingArgs args;

  @override
  State<TripTracking> createState() => _TripTrackingState();
}

class _TripTrackingState extends State<TripTracking> {
  late GoogleMapController _mapController;
  late DirectionService _directionService;
  LatLng? _fromLatLng;
  LatLng? _toLatLng;
  LatLng? _driverLatLng;
  LatLng? cameraPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  @override
  void initState() {
    super.initState();
    _directionService = DirectionService();
    _getLatLngFromAddress();
  }

  void _moveCamera(LatLng position) {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    }
  }

  Future<void> _getDirections() async {
    if (_fromLatLng == null || _toLatLng == null || _driverLatLng == null) {
      return;
    }
    try {
      List<LatLng> routeCoordinates =
          await _directionService.getRouteCoordinates(_fromLatLng!, _toLatLng!);

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: routeCoordinates,
            color: Colors.green,
            width: 5,
          ),
        };
      });
    } catch (e) {
      safePrint('Error fetching directions: $e');
    }
  }

  void _getLatLngFromAddress() async {
    try {
      setState(() {
        _fromLatLng = widget.args.fromLatLng;
        _toLatLng = widget.args.toLatLng;
        _driverLatLng = widget.args.driverLatLng;
        bool isDriverAccepted =
            widget.args.tripStatus == TripStatus.accepted.name;
        _markers = {
          Marker(
            markerId: const MarkerId('fromLocation'),
            position: _fromLatLng!,
            infoWindow: InfoWindow(title: widget.args.fromAddress),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
          Marker(
            markerId: const MarkerId('toLocation'),
            position: _toLatLng!,
            infoWindow: InfoWindow(title: widget.args.toAddress),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
          if (isDriverAccepted && _driverLatLng != null)
            Marker(
              markerId: const MarkerId('driverLocation'),
              position: _driverLatLng!,
              infoWindow: const InfoWindow(title: 'Driver Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
        };
      });
      await _getDirections();
    } catch (e) {
      safePrint('Error fetching coordinates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fromLatLng == null || _toLatLng == null || _driverLatLng == null) {
      return GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 10));
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoaded || state is LocationMarkerSet) {
            final position = state is LocationLoaded
                ? LatLng(state.position.latitude, state.position.longitude)
                : (state as LocationMarkerSet).location;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_mapController != null) {
                _animateToLocation(position);
              }
            });
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _fromLatLng!,
                    zoom: 10,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _animateToLocation(position);
                  },
                  onTap: (LatLng position) {
                    setState(() {
                      cameraPosition = position;
                    });
                    _moveCamera(position);
                  },
                  markers: _markers,
                  polylines: _polylines,
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      _mapController.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    backgroundColor: AppColors.primary,
                    child: Icon(CupertinoIcons.zoom_out, color: Colors.white),
                  ),
                ),
              ],
            );
          }
          return GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 10));
        },
      ),
    );
  }

  void _animateToLocation(LatLng position) {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 10,
            tilt: 50,
            bearing: 0,
          ),
        ),
      );

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15,
          ),
        ),
      );
    }
  }
}
