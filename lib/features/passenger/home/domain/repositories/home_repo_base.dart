import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../data/models/category_model.dart';

abstract class HomeRepoBase {
  Future<List<CategoryModel>> getCategories();
  Future<List<TripModel>> getRecentTrips();
}