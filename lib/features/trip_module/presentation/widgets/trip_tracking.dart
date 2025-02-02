import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
import '../../../../core/helpers/enums/trip_status.dart';
import '../../../passenger/maps/presentation/manager/location_cubit.dart';
import '../../data/data_sources/direction_service/direction_service.dart';

class TripTracking extends StatefulWidget {
  const TripTracking(
      {super.key, required this.args, required this.driverLatLng});
  final TripTrackingArgs args;
  final LatLng driverLatLng;
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
  bool _isAnimating = false;

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
      setState(() {
        _polylines.clear();
      });
      if (widget.args.tripStatus == TripStatus.pending.name && !_isAnimating) {
        _startAnimation();
      } else if (widget.args.tripStatus == TripStatus.accepted.name) {
        _stopAnimation();
        List<LatLng> routeCoordinates = await _directionService
            .getRouteCoordinates(_driverLatLng!, _fromLatLng!);
        setState(() {
          _polylines.add(Polyline(
            polylineId: const PolylineId('driverToFrom'),
            points: routeCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });
      } else {
        List<LatLng> routeCoordinates = await _directionService
            .getRouteCoordinates(_fromLatLng!, _toLatLng!);
        setState(() {
          _polylines.add(Polyline(
            polylineId: const PolylineId('fromTo'),
            points: routeCoordinates,
            color: Colors.green,
            width: 5,
          ));
        });
      }

      if (_driverLatLng != null && _driverLatLng == _fromLatLng) {
        setState(() async {
          _markers.removeWhere(
              (marker) => marker.markerId.value == 'driverLocation');
          _markers.add(Marker(
            markerId: const MarkerId('sharedLocation'),
            position: _fromLatLng!,
            infoWindow: const InfoWindow(title: 'Driver & Passenger Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
          ));

          List<LatLng> finalRoute = await _directionService.getRouteCoordinates(
              _fromLatLng!, _toLatLng!);
          setState(() {
            _polylines.add(Polyline(
              polylineId: const PolylineId('driverToTo'),
              points: finalRoute,
              color: Colors.red,
              width: 5,
            ));
          });
        });
      }
    } catch (e) {
      safePrint('Error fetching directions: $e');
    }
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
    });
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_fromLatLng!, 15),
    );
  }

  void _stopAnimation() {
    setState(() {
      _isAnimating = false;
    });
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
        };
        if (isDriverAccepted && _driverLatLng != null) {
          _markers.add(Marker(
            markerId: const MarkerId('driverLocation'),
            position: _driverLatLng!,
            infoWindow: const InfoWindow(title: 'Driver Location'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));
        }
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
                if (widget.driverLatLng != null) {
                  setState(() {
                    _driverLatLng = widget.driverLatLng;
                    _markers.add(Marker(
                      markerId: const MarkerId('driverLocation'),
                      position: widget.driverLatLng,
                      infoWindow: const InfoWindow(title: 'Driver Location'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                    ));
                    _getDirections();
                  });
                }
              }
            });
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.satellite,
                  initialCameraPosition: CameraPosition(
                    target: _fromLatLng!,
                    zoom: 10,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
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
}
