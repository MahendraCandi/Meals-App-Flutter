
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

// the StateNotifierProvider should be working together with StateNotifier class
class FavouritesProviderNotifier extends StateNotifier<List<Meal>> {

  // initializer list using colon (:)
  // super([]) -> pass the empty list of meal to StateNotifier
  FavouritesProviderNotifier() : super([]);

  // we DO NOT ALLOW to add/remove values inside StateNotifier
  // so to change the value, we have to reassign the existing with the new one
  bool toggleMealFavourites(Meal meal) {
    // state is available by StateNotifier
    // the type data of state is depend on the generic type of StateNotifier
    var isFavouriteMeal = state.contains(meal);

    if (isFavouriteMeal) {
      // where function would be create new state of list
      // so it can be reassign to existing state
      // the where logic is to remove the meal assigned in parameter
      state = state.where((stateMeal) => stateMeal.id != meal.id).toList();
      return false;
    } else {
      // this is to add new meal to favourite
      // spread (...) every meal in state and assign it to new empty array list ([])
      // then add new meal after comma
      state = [...state, meal];
      return true;
    }
  }
}

final favouritesMealsProvider =
    StateNotifierProvider<FavouritesProviderNotifier, List<Meal>>((ref) {
  return FavouritesProviderNotifier();
});
