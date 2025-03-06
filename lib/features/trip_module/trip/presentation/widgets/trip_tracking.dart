import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/theming/app_colors.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/helpers/enums/trip_status.dart';
import '../../../../passenger/maps/presentation/manager/location_cubit.dart';
import '../../data/data_sources/direction_service/direction_service.dart';
import '../trip_tracking_args.dart';

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
  final Set<Polyline> _polylines = {};
  // bool _isAnimating = false;
  // Timer? _timer;
  final _polylineCache = <String, List<LatLng>>{};
  Timer? _listenTimer;
  Timer? _pauseTimer;
  bool _isListening = true;

  @override
  void initState() {
    super.initState();
    _directionService = DirectionService();
    _getLatLngFromAddress();
    _startPeriodicUpdate();
  }

  void _startPeriodicUpdate() {
    _listenTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_isListening) {
        _getDirections();
        _isListening = false;
        _pauseTimer =
            Timer(const Duration(seconds: 5), () => _isListening = true);
      }
    });
  }

  // void _stopPeriodicUpdate() {
  //   _timer?.cancel();
  // }

  void _moveCamera(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  Future<void> _getDirections() async {
    if (_fromLatLng == null || _toLatLng == null || _driverLatLng == null) {
      return;
    }
    try {
      final cacheKey = '${_driverLatLng!.latitude},${_driverLatLng!.longitude}'
          '_${_fromLatLng!.latitude},${_fromLatLng!.longitude}'
          '_${_toLatLng!.latitude},${_toLatLng!.longitude}';

      if (_polylineCache.containsKey(cacheKey)) {
        _updatePolyLines(_polylineCache[cacheKey]!);
        return;
      }

      final routes = await _calculateRoutes();
      _polylineCache[cacheKey] = routes;
      _updatePolyLines(routes);
    } catch (e) {
      safePrint('Error fetching directions: $e');
    }
  }

  Future<List<LatLng>> _calculateRoutes() async {
    List<LatLng> routeCoordinates = [];

    if (widget.args.tripStatus == TripStatus.pending.name) {
      routeCoordinates = await _directionService.getRouteCoordinates(
        _fromLatLng!,
        _toLatLng!,
        useCache: true,
      );
    } else if (widget.args.tripStatus == TripStatus.accepted.name) {
      if (_driverLatLng == _fromLatLng) {
        routeCoordinates = await _directionService.getRouteCoordinates(
          _fromLatLng!,
          _toLatLng!,
          useCache: true,
        );
      } else {
        final driverToFrom = await _directionService.getRouteCoordinates(
          _driverLatLng!,
          _fromLatLng!,
          useCache: true,
        );
        final fromToTo = await _directionService.getRouteCoordinates(
          _fromLatLng!,
          _toLatLng!,
          useCache: true,
        );
        routeCoordinates = [...driverToFrom, ...fromToTo];
      }
    }

    return routeCoordinates;
  }

  void _updatePolyLines(List<LatLng> coordinates) {
    if (!mounted) return;

    setState(() {
      _polylines
        ..clear()
        ..add(Polyline(
          polylineId: PolylineId(Uuid().v4()),
          points: coordinates,
          color: _getPolylineColor(),
          width: 5,
        ));
    });
  }

  Color _getPolylineColor() {
    if (widget.args.tripStatus == TripStatus.pending.name) return Colors.green;
    if (_driverLatLng == _fromLatLng) return Colors.red;
    return Colors.blue;
  }

  // void _startAnimation() {
  //   setState(() {
  //     _isAnimating = true;
  //   });
  //   _mapController.animateCamera(
  //     CameraUpdate.newLatLngZoom(_fromLatLng!, 15),
  //   );
  // }

  // void _stopAnimation() {
  //   setState(() {
  //     _isAnimating = false;
  //   });
  // }

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

  @override
  void dispose() {
    _listenTimer?.cancel();
    _pauseTimer?.cancel();
    _polylineCache.clear();
    _mapController.dispose();
    super.dispose();
  }
}
