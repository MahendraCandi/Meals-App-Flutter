import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/category_item.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Meal> meals;

  const CategoriesScreen({super.key, required this.meals});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// SingleTickerProviderStateMixin -> commonly used for widget animation.
// Use TickerProviderStateMixin if we have multiple AnimationController.
class _CategoriesScreenState extends State<CategoriesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      // this should be refer to SingleTickerProviderStateMixin
      vsync: this,
      duration: const Duration(milliseconds: 300),

      // flutter will running the animation based on these values
      // _animationController.value will start with 0
      // then after 300 milliseconds it will change to 1
      lowerBound: 0,
      upperBound: 1,
    );

    // to start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // animation should always be destroy
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    // navigator.push is to insert a new screen into screen stack.
    // So if this method is trigger, then CategoriesScreen would be in the bottom of MealsScreen.
    // And if we clicked the back button (which will created automatically by Flutter) in the MealsScreen,
    // then the MealsScreen would be pop out from the screen stack and CategoriesScreen would be displayed.
    var filteredByCategoriesMeals = widget.meals.where((meal) =>
        meal.categories.contains(category.id)).toList();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MealsScreen(
        title: category.title,
        meals: filteredByCategoriesMeals,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // explicit animation
    // widget to execute the animation
    return AnimatedBuilder(
      animation: _animationController,

      // this child will not be re-build every time animation run
      child: GridView(
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
      builder: (ctx, child) => SlideTransition(
        position: Tween(
          // x and y axis position in percent
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate( // Tween widget can return AnimationController
          CurvedAnimation(
              parent: _animationController,
              curve: Curves.bounceInOut,
          ),
        ),
        child: child,
      ),

      // the Padding inside the builder param will always re-build whenever animation run
      // builder: (ctx, child) => Padding(
      //   padding: EdgeInsets.only(top: 100 - (_animationController.value * 100)),
      //   // this child refer to child on AnimatedBuilder
      //   child: child,
      // ),
    );
  }

}
