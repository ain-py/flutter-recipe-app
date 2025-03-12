import 'package:flutter/material.dart';
import 'package:recipe_app/models/meals.dart';
import 'package:recipe_app/screens/full_recipe_details.dart';
import 'package:recipe_app/services/api_services.dart';

class RecipesFromCanada extends StatefulWidget {
  RecipesFromCanada({Key? key}) : super(key: key);

  @override
  State<RecipesFromCanada> createState() => _RecipesFromCanadaState();
}

class _RecipesFromCanadaState extends State<RecipesFromCanada> {
  final ApiService apiService = ApiService();

  Widget _buildRecipeCard(BuildContext context, Meal meal) {
    bool isFavourite = false;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullRecipeDetails(
              recipeId: meal.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                meal.thumbnail,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 5),
                      const Text(
                        'Canada',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'Recipes from Canada',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        FutureBuilder<List<Meal>>(
          future: apiService.fetchMealsFromCanada(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text('No Recipes Found')),
              );
            } else {
              final meals = snapshot.data!;
              return Column(
                children: meals
                    .map((meal) => _buildRecipeCard(context, meal))
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }
}
