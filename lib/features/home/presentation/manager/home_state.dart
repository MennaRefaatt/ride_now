part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  HomeLoaded({required this.categories});
}
final class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
