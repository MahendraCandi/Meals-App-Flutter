import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/screens/categories_screen.dart';
import 'package:meals_app/screens/filters_screen.dart';
import 'package:meals_app/screens/meals_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';

// to use provider, we have to change statefulWidget to ConsumerStatefulWidget
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }

}

// to use provider, we have to change State to Consumer State
class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndexPage = 0;

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

      // since we used Provider, then no need to get data after pop a screen
      Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const FiltersScreen()));

    }
  }

  @override
  Widget build(BuildContext context) {

    var filteredMeals = ref.watch(filtersMealProvider);

    Widget activePage = CategoriesScreen(meals: filteredMeals);
    var activePageTitle = "Categories";

    if (_selectedIndexPage == 1) {
      var favouriteMeals = ref.watch(favouritesMealsProvider);
      activePage = MealsScreen(meals: favouriteMeals);
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
