import 'package:flutter/material.dart';
import 'package:recipe_app/models/meals.dart';
import 'package:recipe_app/services/api_services.dart';

class RecipeDetailProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  Meal? _meal;
  bool _isLoading = false;

  Meal? get meal => _meal;
  bool get isLoading => _isLoading;

  bool get loading => _isLoading;

  Future<void> fetchRecipe(String recipeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _meal = await apiService.getMealDetails(recipeId);
    } catch (e) {
      _meal = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
