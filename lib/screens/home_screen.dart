import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controller/meal_provider.dart';
import 'package:recipe_app/screens/full_recipe_details.dart';

import '../widgets/trending_recp.dart';
import '../widgets/recp_country.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_circle_rounded),
        ),
        title: const Text('Recipe App'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          // Search Bar (Pinned)
          SliverAppBar(
            pinned: true,
            //  automaticallyImplyLeading: false,
            elevation: 2,
            // scrolledUnderElevation: 07,
            backgroundColor: Colors.transparent,
            toolbarHeight: 90,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Consumer<MealProvider>(
                builder: (context, mealProvider, _) => TextField(
                  controller: _searchController,
                  onChanged: mealProvider.searchMeals,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0.8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        width: 0.8,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        mealProvider.clearSearch();
                      },
                      icon: const Icon(Icons.clear, color: Colors.grey),
                    ),
                    hintText: 'Search Recipes',
                  ),
                ),
              ),
            ),
          ),

          // Search Results
          Consumer<MealProvider>(
            builder: (context, mealProvider, _) {
              if (_searchController.text.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              } else if (mealProvider.isLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else if (mealProvider.meals.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('No Results')),
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final meal = mealProvider.meals[index];
                      return ListTile(
                        leading: Image.network(
                          meal.thumbnail,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(meal.name),
                        subtitle: Text('${meal.area} • ${meal.category}'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return FullRecipeDetails(recipeId: meal.id);
                          }));
                        },
                      );
                    },
                    childCount: 3,
                  ),
                );
              }
            },
          ),

          // Existing UI widgets
          SliverToBoxAdapter(
            child: TrendingRecipes(),
          ),
          SliverToBoxAdapter(
            child: RecipesFromCanada(),
          ),
        ],
      ),
    );
  }
}
