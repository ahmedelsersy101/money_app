import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/category_utils.dart';

class CategoryState {
  final List<CategoryDetails> categories;
  final bool isLoading;

  CategoryState({required this.categories, this.isLoading = false});

  CategoryState copyWith({List<CategoryDetails>? categories, bool? isLoading}) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<CategoryDetails> get expenseCategories => categories.where((c) => !c.isIncome).toList();
  List<CategoryDetails> get incomeCategories => categories.where((c) => c.isIncome).toList();
}

class CategoryCubit extends Cubit<CategoryState> {
  final SharedPreferences sharedPreferences;

  CategoryCubit({required this.sharedPreferences})
    : super(CategoryState(categories: CategoryUtils.categories)) {
    loadCustomCategories();
  }

  void loadCustomCategories() {
    final customJson = sharedPreferences.getStringList('custom_categories') ?? [];
    if (customJson.isEmpty) return;

    final customCategories = customJson
        .map((e) => CategoryDetails.fromJson(jsonDecode(e)))
        .toList();

    // Merge with default categories
    final allCategories = List<CategoryDetails>.from(CategoryUtils.categories);
    allCategories.addAll(customCategories);

    emit(state.copyWith(categories: allCategories));
  }

  Future<void> addCategory(String name, bool isIncome) async {
    final newCategory = CategoryDetails(
      key: name, // Using name as key for simplicity
      isIncome: isIncome,
    );

    final updatedCategories = List<CategoryDetails>.from(state.categories)..add(newCategory);
    emit(state.copyWith(categories: updatedCategories));

    // Save only custom categories
    final customJson = sharedPreferences.getStringList('custom_categories') ?? [];
    customJson.add(jsonEncode(newCategory.toJson()));
    await sharedPreferences.setStringList('custom_categories', customJson);
  }
}
