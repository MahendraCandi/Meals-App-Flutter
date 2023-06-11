import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context, Category category) {
    // navigator.push is to insert a new screen into screen stack.
    // So if this method is trigger, then CategoriesScreen would be in the bottom of MealsScreen.
    // And if we clicked the back button (which will created automatically by Flutter) in the MealsScreen,
    // then the MealsScreen would be pop out from the screen stack and CategoriesScreen would be displayed.
    var filteredMeals = dummyMeals.where((meal) =>
        meal.categories.contains(category.id)).toList();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MealsScreen(
        title: category.title,
        meals: filteredMeals,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick your category"),
      ),
      body: GridView(
        padding: const EdgeInsets.all(24),
        // this sliverGrid will create a grid view with 2 item on a row
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          ...availableCategories
              .map((category) => CategoryItem(
                  category: category,
                  showDetailCategory: () => _selectCategory(context, category)))
              .toList(),
        ],
      ),
    );
  }

}