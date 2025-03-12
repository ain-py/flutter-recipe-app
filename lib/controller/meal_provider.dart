import 'package:flutter/material.dart';
import 'package:recipe_app/models/meals.dart';
import 'package:recipe_app/services/api_services.dart';

class MealProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  List<Meal> _meals = [];
  bool _isLoading = false;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      _meals = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _meals = await apiService.searchMeals(query);
    } catch (e) {
      _meals = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _meals = [];
    notifyListeners();
  }
}
