import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/enums/filter_map.dart';

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
