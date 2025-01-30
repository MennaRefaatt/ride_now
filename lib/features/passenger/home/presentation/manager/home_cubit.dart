import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import '../../../../trip_module/data/models/trip_model.dart';
import '../../data/models/category_model.dart';
import '../../domain/repositories/home_repo_base.dart';
import '../widgets/enter_your_route.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.homeRepoBase}) : super(HomeInitial()) {
    fromController = TextEditingController();
    toController = TextEditingController();
  }
  final HomeRepoBase homeRepoBase;
  late TextEditingController fromController;
  late TextEditingController toController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final fromFocusNode = FocusNode();
  final toFocusNode = FocusNode();
  LatLng? fromLatLng, toLatLng;
  void updateCost(double newCost) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoaded(
        categories: currentState.categories,
        trips: currentState.trips,
        cost: newCost,
      ));
    }
  }

  Future<void> getCategoriesAndTrips() async {
    emit(HomeLoading());
    try {
      final categoriesFuture = homeRepoBase.getCategories();
      final tripsFuture = homeRepoBase.getRecentTrips();

      final categories = await categoriesFuture;
      final trips = await tripsFuture;

      safePrint('Categories and trips loaded successfully');
      emit(HomeLoaded(categories: categories, trips: trips, cost: null));
    } catch (e) {
      safePrint('Error loading categories and trips: $e');
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> getCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await homeRepoBase.getCategories();
      safePrint('Categories loaded successfully');
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      safePrint('Error loading categories: $e');
      emit(CategoriesError(message: e.toString()));
    }
  }

  Future<void> getTrips() async {
    emit(GetRecentTripsLoading());
    try {
      final trips = await homeRepoBase.getRecentTrips();
      emit(GetRecentTripsLoaded(trips: trips));
    } catch (e) {
      emit(GetRecentTripsError(message: e.toString()));
    }
  }

  void openEnterYourRoute(
      BuildContext context,
      FocusNode fromFocusNode,
      FocusNode toFocusNode,
      String fromText,
      Color backgroundColor,
      HomeCubit homeCubit,
      final List<TripModel> trips) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return EnterYourRoute(
          fromFocusNode: fromFocusNode,
          toFocusNode: toFocusNode,
          fromText: fromText,
          backgroundColor: backgroundColor,
          cubit: homeCubit,
          trips: trips,
        );
      },
    );
  }
}
