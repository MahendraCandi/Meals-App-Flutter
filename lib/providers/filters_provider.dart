import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/enums/filter_map.dart';
import 'package:meals_app/providers/meals_provider.dart';

class FiltersProviderNotifier extends StateNotifier<Map<FilterMapKey, bool>> {
  FiltersProviderNotifier() : super({
    FilterMapKey.includeGlutenFree: false,
    FilterMapKey.includeLactoseFree: false,
    FilterMapKey.includeVegetarian: false,
    FilterMapKey.includeVegan: false,
  });

  setFilters(Map<FilterMapKey, bool> newFilters) {
    state = newFilters;
  }

  setFilter(FilterMapKey filterKey, bool isFiltered) {
    // this is to reassign Map type
    state = {
      ...state,
      filterKey: isFiltered
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersProviderNotifier, Map<FilterMapKey, bool>>(
        (ref) => FiltersProviderNotifier());

// use provider that depends on another provider
final filtersMealProvider = Provider((ref) {
  var meals = ref.watch(mealProvider);
  var checkedFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    // if the meal is not gluten free then should not include immediately
    if (checkedFilters[FilterMapKey.includeGlutenFree]! && !meal.isGlutenFree) {
      return false; // no include
    }
    if (checkedFilters[FilterMapKey.includeLactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (checkedFilters[FilterMapKey.includeVegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (checkedFilters[FilterMapKey.includeVegan]! && !meal.isVegan) {
      return false;
    }

    return true; // include
  }).toList();
});
