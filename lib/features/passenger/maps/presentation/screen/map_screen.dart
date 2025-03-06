import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/features/passenger/maps/presentation/widgets/done_button.dart';
import 'package:ride_now/features/passenger/maps/presentation/widgets/map_action_buttons.dart';
import 'package:ride_now/features/passenger/maps/presentation/widgets/selected_location_container.dart';
import '../../../../../core/di/di.dart';
import '../manager/location_cubit.dart';
import '../maps_args.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.mapsArgs});
  final MapsArgs mapsArgs;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  @override
  void initState() {
    super.initState();
    if (widget.mapsArgs.initialLatitude != null &&
        widget.mapsArgs.initialLongitude != null) {
      _selectedLocation = LatLng(
          widget.mapsArgs.initialLatitude!, widget.mapsArgs.initialLongitude!);
    } else {
      Future.microtask(() => context.read<LocationCubit>().fetchUserLocation());
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    final theme = Theme.of(context);

    if (theme.brightness == Brightness.dark) {
      String style = await DefaultAssetBundle.of(context)
          .loadString('assets/map_styles/dark_map_style.json');
      _mapController.setMapStyle(style);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(sl(), sl(), sl())..fetchUserLocation(),
      child: Scaffold(
        body: BlocSelector<LocationCubit, LocationState, Map<String, dynamic>?>(
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
        }, builder: (context, data) {
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (position != _selectedLocation) {
              _selectedLocation = position;
              _selectedAddress = address;
            }
          });

          return Stack(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _selectedLocation ?? position,
                        zoom: 15,
                      ),
                      onMapCreated: _onMapCreated,
                      zoomControlsEnabled: false,
                      markers: _selectedLocation != null
                          ? {
                              Marker(
                                markerId: const MarkerId('selectedLocation'),
                                infoWindow: InfoWindow(
                                  title: _selectedAddress ?? address.toString(),
                                ),
                                position: _selectedLocation!,
                                icon: BitmapDescriptor.defaultMarkerWithHue(
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
                      SelectedLocationContainer(address: address),
                    DoneButton(
                        selectedAddress: _selectedAddress,
                        selectedLocation: _selectedLocation,
                        address: address),
                    MapActionButtons(
                      zoomIn: _zoomIn,
                      zoomOut: _zoomOut,
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _zoomIn() {
    _mapController.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void _zoomOut() {
    _mapController.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    context.read<LocationCubit>().stopTrackingLocation();
    super.dispose();
  }
}
