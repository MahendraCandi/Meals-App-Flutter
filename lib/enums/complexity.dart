enum Complexity {
  simple,
  challenging,
  hard;

  String get capitalize {
    return name[0].toUpperCase() + name.substring(1);
  }
}
