import '../../data/models/category_model.dart';

abstract class CategoriesRepoBase {
  Future<List<CategoryModel>> getCategories();
}