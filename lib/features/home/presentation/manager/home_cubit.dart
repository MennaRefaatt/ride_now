import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../../data/models/category_model.dart';
import '../../domain/repositories/category_repo_base.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.categoriesRepo}) : super(HomeInitial());
  final CategoriesRepoBase categoriesRepo;

  Future<void> getCategories() async {
    emit(HomeLoading());
    try {
      final categories = await categoriesRepo.getCategories();
      safePrint('Categories loaded successfully');
      emit(HomeLoaded(categories: categories));
    } catch (e) {
      safePrint('Error loading categories: $e');
      emit(HomeError(message: e.toString()));
    }
  }
}
