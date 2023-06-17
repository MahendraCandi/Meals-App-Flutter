import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  final String title;
  final List<Meal> meals;

  const MealsScreen({super.key, required this.title, required this.meals});

  @override
  Widget build(BuildContext context) {
    Widget content = meals.isNotEmpty ? _showMeals() : _showNoMeals(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: content,
    );
  }

  _selectMealDetail(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) {
        return MealDetailScreen(meal: meal);
      },
    ));
  }

  ListView _showMeals() {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        var meal = meals[index];
        return MealItem(
          meal: meal,
          onSelectMealDetail: () => _selectMealDetail(ctx, meal),
        );
      },
    );
  }

  Center _showNoMeals(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Nothing here",
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            "Please check different categories",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );
  }
}
