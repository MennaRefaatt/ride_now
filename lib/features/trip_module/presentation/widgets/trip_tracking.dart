import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/features/maps/presentation/manager/location_cubit.dart';
import 'package:ride_now/features/trip_module/presentation/trip_tracking_args.dart';
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
  Set<Polyline> _polylines = {};
  LatLng? cameraPosition;

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
    if (_fromLatLng == null || _toLatLng == null) return;
    try {
      List<LatLng> routeCoordinates =
          await _directionService.getRouteCoordinates(_fromLatLng!, _toLatLng!);

      setState(() {
        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
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

  Future<void> _getLatLngFromAddress() async {
    try {
      final fromPlacemark = await locationFromAddress(widget.args.fromAddress);
      final toPlacemark = await locationFromAddress(widget.args.toAddress);

      setState(() {
        _fromLatLng =
            LatLng(fromPlacemark.first.latitude, fromPlacemark.first.longitude);
        _toLatLng =
            LatLng(toPlacemark.first.latitude, toPlacemark.first.longitude);
      });
      _getDirections();
    } catch (e) {
      safePrint('Error fetching coordinates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fromLatLng == null || _toLatLng == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final markers = {
      Marker(
        markerId: const MarkerId('fromLocation'),
        position: _fromLatLng!,
        infoWindow: InfoWindow(title: widget.args.fromAddress),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('toLocation'),
        position: _toLatLng!,
        infoWindow: InfoWindow(title: widget.args.toAddress),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

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
            return GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                target: _fromLatLng!,
                zoom: 10,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _animateToLocation(position);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(
                      LatLngBounds(
                        southwest: LatLng(
                          _fromLatLng!.latitude < _toLatLng!.latitude
                              ? _fromLatLng!.latitude
                              : _toLatLng!.latitude,
                          _fromLatLng!.longitude < _toLatLng!.longitude
                              ? _fromLatLng!.longitude
                              : _toLatLng!.longitude,
                        ),
                        northeast: LatLng(
                          _fromLatLng!.latitude > _toLatLng!.latitude
                              ? _fromLatLng!.latitude
                              : _toLatLng!.latitude,
                          _fromLatLng!.longitude > _toLatLng!.longitude
                              ? _fromLatLng!.longitude
                              : _toLatLng!.longitude,
                        ),
                      ),
                      100.0,
                    ),
                  );
                });
              },
              onTap: (LatLng position) {
                setState(() {
                  cameraPosition = position;
                });
                _moveCamera(position);
              },
              markers: markers,
              polylines: _polylines,
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
            zoom: 18,
            tilt: 50,
            bearing: 0,
          ),
        ),
      );

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 18,
          ),
        ),
      );
    }
  }
}
