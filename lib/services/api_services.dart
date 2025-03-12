import 'dart:convert';
import 'package:recipe_app/models/meals.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final meals = data['meals'] as List?;

      if (meals != null) {
        return meals.map((meal) => Meal.fromJson(meal)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<Meal?> getMealDetails(String recipeId) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$recipeId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final meals = jsonData['meals'] as List?;
      if (meals != null && meals.isNotEmpty) {
        return Meal.fromJson(meals.first);
      }
    }
    return null;
  }

  Future<List<Meal>> fetchTrendingMeals() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?a=Indian'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final meals = data['meals'] as List?;
      if (meals != null) {
        return meals.map((json) => Meal.fromJson(json)).toList();
      }
    }
    return [];
  }

  Future<List<Meal>> fetchMealsFromCanada() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?a=Canadian'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final meals = data['meals'] as List?;
      if (meals != null) {
        return meals.map((meal) => Meal.fromJson(meal)).toList();
      }
    }
    return [];
  }
}
