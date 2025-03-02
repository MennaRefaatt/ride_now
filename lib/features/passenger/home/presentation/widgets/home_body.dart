import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_now/core/helpers/spacing.dart';
import 'package:ride_now/features/passenger/home/presentation/widgets/order_button.dart';
import '../../../../../core/theming/app_colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../../generated/l10n.dart';
import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../../maps/presentation/manager/location_cubit.dart';
import '../manager/home_cubit.dart';
import '../widgets/ride_categories.dart';
import '../widgets/where_to_bar.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.homeCubit, required this.isHidden});
  final bool isHidden;
  final HomeCubit homeCubit;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  double? cost;
  void openEnterYourRouteFromOrderButton(BuildContext context) {
    final locationState = context.read<LocationCubit>().state;
    final homeState = context.read<HomeCubit>().state;
    String fromText = S().fromWhere;
    Color backgroundColor = Colors.grey.shade200;
    List<TripModel> trips = [];

    if (locationState is LocationLoaded) {
      fromText = locationState.address;
      backgroundColor = Colors.transparent;
    }
    if (homeState is GetRecentTripsLoaded) {
      trips = homeState.trips;
    }
    widget.homeCubit.openEnterYourRoute(
        context,
        widget.homeCubit.fromFocusNode,
        widget.homeCubit.toFocusNode,
        fromText,
        backgroundColor,
        widget.homeCubit,
        trips);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          widget.isHidden ? 300.h : 0,
          0,
        ),
        width: double.infinity,
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.r),
            topLeft: Radius.circular(40.r),
          ),
        ),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return CircularProgressIndicator();
            } else if (state is HomeLoaded) {
              final categories = state.categories;
              final trips = state.trips;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RideCategories(
                      categories: categories,
                      onCategorySelected: (category) {
                        setState(() {
                          widget.homeCubit.selectedCategory = category;
                        });
                      },
                    ),
                    WhereToBar(
                      cubit: widget.homeCubit,
                      lastTrips: trips,
                      toLatLng: widget.homeCubit.toLatLng,
                    ),
                    Row(
                      children: [
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            if (state is CostUpdated) {
                              return Container(
                                padding: EdgeInsets.all(10.sp),
                                margin: EdgeInsets.all(10.sp),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.money_dollar,
                                      color: AppColors.primary,
                                      size: 30.sp,
                                    ),
                                    horizontalSpacing(5),
                                    Text(
                                      state.cost != 0.0
                                          ? state.cost.toStringAsFixed(2)
                                          : '',
                                      style: TextStyles.font18BlackBold,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),
                        OrderButton(
                            homeCubit: widget.homeCubit,
                            openEnterYourRouteFromOrderButton:
                                openEnterYourRouteFromOrderButton)
                      ],
                    )
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Text('Error: ${state.message}');
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
