import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/enums/filter_map.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/filters_screen.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitiateFilters = {
  FilterMapKey.includeGlutenFree: false,
  FilterMapKey.includeLactoseFree: false,
  FilterMapKey.includeVegetarian: false,
  FilterMapKey.includeVegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return TabsScreenState();
  }

}

class TabsScreenState extends State<TabsScreen> {
  int _selectedIndexPage = 0;
  final List<Meal> _favouriteMeals = [];
  Map<FilterMapKey, bool> _checkedFilters = kInitiateFilters;

  void _showInfoMessage (String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavourites(Meal meal) {
    var isFavouriteMeal = _favouriteMeals.contains(meal);

    if (isFavouriteMeal) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showInfoMessage("Removed meal from favourites");
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showInfoMessage("Added meal to favorites");
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndexPage = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      // instead push new screen into a stack,
      // we can replace screen using pushReplacement
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (ctx) => const FiltersScreen()));

      var filterResults = await Navigator.of(context).push<Map<FilterMapKey, bool>>(
          MaterialPageRoute(builder: (ctx) => FiltersScreen(currentFilter: _checkedFilters,)));

      setState(() {
        _checkedFilters = filterResults ?? kInitiateFilters;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    var filteredMeals = dummyMeals.where((meal) {
      // if the meal is not gluten free then should not include immediately
      if (_checkedFilters[FilterMapKey.includeGlutenFree]! && !meal.isGlutenFree) {
        return false; // no include
      }
      if (_checkedFilters[FilterMapKey.includeLactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_checkedFilters[FilterMapKey.includeVegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_checkedFilters[FilterMapKey.includeVegan]! && !meal.isVegan) {
        return false;
      }

      return true; // include
    }).toList();

    Widget activePage = CategoriesScreen(onToggleFavourite: _toggleMealFavourites, meals: filteredMeals);
    var activePageTitle = "Categories";

    if (_selectedIndexPage == 1) {
      activePage = MealsScreen(meals: _favouriteMeals, onToggleFavourite: _toggleMealFavourites,);
      activePageTitle = "Favourites";
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedIndexPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}
