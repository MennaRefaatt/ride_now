import '../../../../trip_module/trip/data/models/trip_model.dart';
import '../../domain/repositories/home_repo_base.dart';
import '../data_sources/home_remote_ds.dart';
import '../models/category_model.dart';
class HomeRepoImpl implements HomeRepoBase {
  final HomeRemoteDS homeRemoteDS;
  HomeRepoImpl({required this.homeRemoteDS});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categories = await homeRemoteDS.getCategories();
      return categories;
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  @override
  Future<List<TripModel>> getRecentTrips() async {
    try {
      final trips = await homeRemoteDS.getRecentTrips();
      return trips;
    } catch (e) {
      throw Exception("Error fetching trips: $e");
    }
  }
}
