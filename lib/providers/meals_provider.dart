import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';

// the Provider class only use to share const/static/final state (variable/value)
// DON'T use this for complex data/state that would be changed dynamically
// instead use StateNotifierProvider
final mealProvider = Provider((ref) {
  return dummyMeals;
});
