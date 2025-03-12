import 'package:flutter/material.dart';
import 'package:recipe_app/models/meals.dart';
import 'package:recipe_app/screens/full_recipe_details.dart';
import 'package:recipe_app/services/api_services.dart';

class TrendingRecipes extends StatelessWidget {
  TrendingRecipes({Key? key}) : super(key: key);

  final ApiService apiService = ApiService();

  Widget _buildRecipeCard(BuildContext context, Meal meal) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullRecipeDetails(
            recipeId: meal.id,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: 320.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                meal.thumbnail,
                height: 120.0,
                width: 110.0,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      meal.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        const Text(
                          "4.5",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            'Trending Recipes',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(
          height: 150.0,
          child: FutureBuilder<List<Meal>>(
            future: apiService.fetchTrendingMeals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Trending Recipes'));
              } else {
                final meals = snapshot.data!;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return _buildRecipeCard(context, meals[index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
