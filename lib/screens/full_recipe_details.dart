import 'package:flutter/material.dart';
import 'package:recipe_app/controller/recipe_detail_provider.dart';
import 'package:recipe_app/models/meals.dart';
import 'package:provider/provider.dart';

class FullRecipeDetails extends StatefulWidget {
  final String recipeId;

  const FullRecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  _FullRecipeDetailsState createState() => _FullRecipeDetailsState();
}

class _FullRecipeDetailsState extends State<FullRecipeDetails> {
  @override
  void initState() {
    super.initState();
    // call after the widget is rendered
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<RecipeDetailProvider>(context, listen: false)
          .fetchRecipe(widget.recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeDetailProvider>(context);

    return Scaffold(
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.meal == null
              ? const Center(child: Text('Recipe not found'))
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 250,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(provider.meal!.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            )),
                        background: Image.network(
                          provider.meal!.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.meal!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Chip(label: Text(provider.meal!.category)),
                                const SizedBox(width: 10),
                                Chip(
                                  label: Text(provider.meal!.area),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildIngredientsList(provider.meal!),
                            const SizedBox(height: 20),
                            const Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              provider.meal!.instructions,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget buildIngredientsList(Meal meal) {
    final ingredients = <Widget>[];

    final ingredient = meal.ingredients;
    final measure = meal.measures;
    // print(ingredient);
    // print(measure);
    for (int i = 0; i < ingredient.length; i++) {
      if (ingredient[i].isNotEmpty && measure[i].isNotEmpty) {
        ingredients.add(
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text('${ingredient[i]} - ${measure[i]}'),
          ),
        );
      }
    }

    return Column(children: ingredients);
  }
}
