part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<TripModel> trips;
  final double? cost;

  HomeLoaded({required this.categories, required this.trips,required this.cost});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

final class CategoriesLoading extends HomeState {}

final class CategoriesLoaded extends HomeState {
  final List<CategoryModel> categories;
  CategoriesLoaded({required this.categories});
}

final class CategoriesError extends HomeState {
  final String message;
  CategoriesError({required this.message});
}

final class GetRecentTripsLoading extends HomeState {}

final class GetRecentTripsLoaded extends HomeState {
  final List<TripModel> trips;
  GetRecentTripsLoaded({required this.trips});
}

final class GetRecentTripsError extends HomeState {
  final String message;
  GetRecentTripsError({required this.message});
}
