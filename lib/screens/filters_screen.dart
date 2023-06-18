
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/enums/filter_map.dart';
import 'package:meals_app/providers/filters_provider.dart';

class FiltersScreen extends ConsumerWidget {

  const FiltersScreen({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var activeFilters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Filters"),
      ),
      body: Column(
        children: [
          buildSwitchListTile(
            context,
            "Gluten-free",
            "Only include gluten free meals",
            activeFilters[FilterMapKey.includeGlutenFree]!,
            (isChecked) => ref.read(filtersProvider.notifier).setFilter(FilterMapKey.includeGlutenFree, isChecked),
          ),
          buildSwitchListTile(
            context,
            "Lactose-free",
            "Only include Lactose-free meals",
            activeFilters[FilterMapKey.includeLactoseFree]!,
                (isChecked) => ref.read(filtersProvider.notifier).setFilter(FilterMapKey.includeLactoseFree, isChecked),
          ),
          buildSwitchListTile(
            context,
            "Vegetarian",
            "Only include Vegetarian meals",
            activeFilters[FilterMapKey.includeVegetarian]!,
                (isChecked) => ref.read(filtersProvider.notifier).setFilter(FilterMapKey.includeVegetarian, isChecked),
          ),
          buildSwitchListTile(
            context,
            "Vegan",
            "Only include Vegan meals",
            activeFilters[FilterMapKey.includeVegan]!,
                (isChecked) => ref.read(filtersProvider.notifier).setFilter(FilterMapKey.includeVegan, isChecked),
          ),
        ],
      ),
    );
  }

  SwitchListTile buildSwitchListTile(BuildContext context, String title, String subtitle, bool value, Function(bool isChecked) onChecked) {
    return SwitchListTile(
      // create check widget
      value: value,
      onChanged: onChecked,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }
}
