import '../../domain/repositories/category_repo_base.dart';
import '../data_sources/category_remote_ds.dart';
import '../models/category_model.dart';
class CategoriesRepoImpl implements CategoriesRepoBase {
  final CategoriesRemoteDS categoriesRemoteDS;
  CategoriesRepoImpl({required this.categoriesRemoteDS});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final categories = await categoriesRemoteDS.getCategories();
      return categories;
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }
}
