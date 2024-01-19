class Category {
  final int id;
  final String name;
  const Category({
    required this.id,
    required this.name,
  });
}

class Subcategory {
  final int id;
  final String name;
  final Category category;
  const Subcategory({
    required this.id,
    required this.name,
    required this.category,
  });
}
