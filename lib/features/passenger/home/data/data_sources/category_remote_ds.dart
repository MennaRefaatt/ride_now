import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../models/category_model.dart';

abstract class CategoriesRemoteDS {
  Future<List<CategoryModel>> getCategories();
}

class CategoriesRemoteDSImpl implements CategoriesRemoteDS {
  @override
  Future<List<CategoryModel>> getCategories() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore.collection('categories').get();
      return querySnapshot.docs
          .map((doc) {
        final data = doc.data();
        safePrint(data);
        return CategoryModel.fromJson(data);
      })
          .toList();
    } catch (e) {
      throw Exception("Error getting categories: $e");
    }
  }
}
