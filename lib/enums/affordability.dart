enum Affordability {
  affordable,
  pricey,
  luxurious;

  String get capitalize {
    return name[0].toUpperCase() + name.substring(1);
  }
}
