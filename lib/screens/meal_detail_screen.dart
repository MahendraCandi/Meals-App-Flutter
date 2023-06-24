import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/providers/favourites_provider.dart';

// to use Provider, change StatelessWidget into ConsumerWidget
class MealDetailScreen extends ConsumerWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal,});

  // ConsumerWidget require WidgetRef in build function
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var favouriteMeals = ref.watch(favouritesMealsProvider);
    var isFavourite = favouriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
              onPressed: () {
                // ref.read -> to read provider once
                // use this instead of watch, because we only need to call the function
                // not require to consume the data
                // notifier in favouritesMealsProvider.notifier will call FavouritesProviderNotifier
                var isAdded = ref.read(favouritesMealsProvider.notifier)
                    .toggleMealFavourites(meal);

                _showInfoMessage(context,
                    isAdded ? "Added as favourite" : "Removed favourite");
              },

            // implicit animation
            // AnimatedSwitcher -> transition between two values
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  // we can put animation param as default value from flutter
                  // turns: animation,
                  // or we can use one of Animatable object like Tween to override default value from flutter
                  turns: Tween<double>(begin: 0.85, end: 1).animate(animation),
                  child: child,
                );
              },
              child: Icon(isFavourite ? Icons.star : Icons.star_border,
                // the AnimationSwitcher couldn't detect the changed of icon because it still Icon widget
                // therefor we need to detect changed value inside the Icon widget
                // the key param can be used to detect the changed value
                key: ValueKey(isFavourite),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero( // to animate widgets across between screen (the target and the source)
              // to identified which widget should be animated
              // this widget will be animated as target (where it going)
              // please check the source on lib/widgets/meal_item.dart:28
              tag: meal.id,
              child: Image(
                image: NetworkImage(meal.imageUrl), // get image from url
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity, // to take all available width space
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 14),
            for (var ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
            const SizedBox(height: 14),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (var step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // to align each number on top left
                  children: [
                    Text(
                      "${meal.steps.indexOf(step) + 1}.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        step,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void _showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

}
