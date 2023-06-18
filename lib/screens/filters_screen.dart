
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/enums/filter_map.dart';
import 'package:meals_app/providers/filters_provider.dart';

class FiltersScreen extends ConsumerStatefulWidget {

  const FiltersScreen({super.key,});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  var _glutenFreeSet = false;
  var _lactoseFreeSet = false;
  var _vegetarianSet = false;
  var _veganSet = false;


  @override
  void initState() {
    super.initState();
    // ref.read call the value once because it used in initState
    Map<FilterMapKey, bool> filteredMeals = ref.read(filtersProvider);

    _glutenFreeSet = filteredMeals[FilterMapKey.includeGlutenFree]!;
    _lactoseFreeSet = filteredMeals[FilterMapKey.includeLactoseFree]!;
    _vegetarianSet = filteredMeals[FilterMapKey.includeVegetarian]!;
    _veganSet = filteredMeals[FilterMapKey.includeVegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Filters"),
      ),
      // commented because it's nice to have back button
      // drawer: MainDrawer(onSelectScreen: (identifier) {
      //   Navigator.of(context).pop();
      //   if (identifier == "meals") {
      //     // instead push new screen into a stack,
      //     // we can replace screen using pushReplacement
      //     Navigator.of(context).pushReplacement(
      //         MaterialPageRoute(builder: (ctx) => const TabsScreen()));
      //   }
      // }),
      body: WillPopScope( // a utility widget commonly used to pass data whenever user leave screen
        onWillPop: () async { // using async because we don't know how long user will be on this screen until they back again to previous screen

          // update logic
          // since we using Provider, we can use it to pass data between screen
          // and return true to pop out the screen
          ref.read(filtersProvider.notifier).setFilters({
            FilterMapKey.includeGlutenFree: _glutenFreeSet,
            FilterMapKey.includeLactoseFree: _lactoseFreeSet,
            FilterMapKey.includeVegetarian: _vegetarianSet,
            FilterMapKey.includeVegan: _veganSet,
          });

          return true;

          // old logic
          // this will be executed when user tap back button.
          // pop function can accept a result parameter, to pass the data whenever a screen is pop from screen's stack.
          // the data will be passed to the previous screen which called this screen via Navigator.push
          // Navigator.of(context).pop({
          //   FilterMapKey.includeGlutenFree: _glutenFreeSet,
          //   FilterMapKey.includeLactoseFree: _lactoseFreeSet,
          //   FilterMapKey.includeVegetarian: _vegetarianSet,
          //   FilterMapKey.includeVegan: _veganSet,
          // });
          // if true then will be back to previous screen
          // if false then no back to previous screen
          // however in above code, since we initiate a Navigator to back manually, then back to previous screen still be executed
          // return false;
        },
        child: Column(
          children: [
            buildSwitchListTile(
              context,
              "Gluten-free",
              "Only include gluten free meals",
              _glutenFreeSet,
              (isChecked) => setState(() => _glutenFreeSet = isChecked),
            ),
            buildSwitchListTile(
              context,
              "Lactose-free",
              "Only include Lactose-free meals",
              _lactoseFreeSet,
              (isChecked) => setState(() => _lactoseFreeSet = isChecked),
            ),
            buildSwitchListTile(
              context,
              "Vegetarian",
              "Only include Vegetarian meals",
              _vegetarianSet,
              (isChecked) => setState(() => _vegetarianSet = isChecked),
            ),
            buildSwitchListTile(
              context,
              "Vegan",
              "Only include Vegan meals",
              _veganSet,
              (isChecked) => setState(() => _veganSet = isChecked),
            ),
          ],
        ),
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
