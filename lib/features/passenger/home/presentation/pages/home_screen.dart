import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import 'package:ride_now/features/passenger/check_out/presentation/check_out_args.dart';
import '../../../../../core/components/app_icon.dart';
import '../../../../../core/components/drawer_items.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';
import '../widgets/ride_categories.dart';
import '../widgets/where_to_bar.dart';

class PassengerHome extends StatefulWidget {
  const PassengerHome({super.key});

  @override
  State<PassengerHome> createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  bool _isHidden = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController _mapController;

  void _onMapSwipe() {
    setState(() {
      _isHidden = true;
    });
  }

  void _onMapStop() {
    setState(() {
      _isHidden = false;
    });
  }

  void _updateCameraPosition(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15,
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

  final homeCubit = HomeCubit(categoriesRepo: sl());
  final locationCubit = LocationCubit(sl(), sl(), sl());
  void _openEnterYourRouteFromOrderButton(BuildContext context) {
    final locationState = context.read<LocationCubit>().state;
    String fromText = 'S().From';
    Color backgroundColor = Colors.grey.shade200;

    if (locationState is LocationLoaded) {
      fromText = locationState.address;
      backgroundColor = Colors.transparent;
    }
    homeCubit.openEnterYourRoute(context, homeCubit.fromFocusNode,
        homeCubit.toFocusNode, fromText, backgroundColor, homeCubit);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locationCubit..fetchUserLocation(),
        ),
        BlocProvider(
          create: (context) => homeCubit..getCategories(),
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerItems(),
        body: Stack(
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state is LocationLoaded || state is LocationMarkerSet) {
                  final position = state is LocationLoaded
                      ? LatLng(
                          state.position.latitude, state.position.longitude)
                      : (state as LocationMarkerSet).location;
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
                          _mapController = controller;
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
                          context
                              .read<LocationCubit>()
                              .setMarker(tappedLocation);
                        },
                      ),
                    ),
                  );
                }
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(30.0444, 31.2357), zoom: 10),
                );
              },
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              left: _isHidden ? -100.w : 20.w,
              top: 40.h,
              curve: Curves.easeOut,
              child: AppIcon(
                withShadow: true,
                icon: Icons.more_horiz,
                backgroundColor: Colors.white,
                iconColor: Colors.black87,
                navigation: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  0,
                  _isHidden ? 300.h : 0,
                  0,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(15.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const RideCategories(),
                    WhereToBar(
                      cubit: homeCubit,
                    ),
                    AppButton(
                      text: "S().Order",
                      textStyle: TextStyles.font14BlackRegular,
                      onPressed: () {
                        if (homeCubit.fromController.text.isEmpty ||
                            homeCubit.toController.text.isEmpty) {
                          //_openEnterYourRouteFromOrderButton(context);
                        }
                        Navigator.pushNamed(context, RoutingEndpoints.checkOut,
                            arguments: CheckOutArgs(
                                fromAddress: homeCubit.fromController.text,
                                toAddress: homeCubit.toController.text));
                        safePrint(homeCubit.toController.text);
                        },
                      backgroundColor: AppColors.primary,
                      width: double.infinity,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
