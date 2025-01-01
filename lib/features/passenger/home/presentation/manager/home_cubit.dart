import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ride_now/core/helpers/safe_print.dart';

import '../../data/models/category_model.dart';
import '../../domain/repositories/category_repo_base.dart';
import '../widgets/enter_your_route.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.categoriesRepo}) : super(HomeInitial()) {
    fromController = TextEditingController();
    toController = TextEditingController();
  }
  final CategoriesRepoBase categoriesRepo;
  late TextEditingController fromController;
  late TextEditingController toController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final fromFocusNode = FocusNode();
  final toFocusNode = FocusNode();

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

  void openEnterYourRoute(
      BuildContext context,
      FocusNode fromFocusNode,
      FocusNode toFocusNode,
      String fromText,
      Color backgroundColor,
      HomeCubit homeCubit) {
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
        );
      },
    );
  }
}
