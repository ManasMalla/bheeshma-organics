import 'package:bheeshmaorganics/data/entitites/category.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final categories = const [
    Category(id: 0, name: 'Dry Fruits'),
    Category(id: 1, name: 'Herbals'),
    Category(id: 2, name: 'Grains & Pulses'),
    Category(id: 3, name: 'Spices'),
    Category(id: 4, name: 'Cold Pressed Oils'),
    Category(id: 5, name: 'Millets'),
    Category(id: 6, name: 'Hair care'),
    Category(id: 7, name: 'Body care'),
    Category(id: 8, name: 'Oral care'),
    Category(id: 9, name: 'Ice creams'),
    Category(id: 10, name: 'Gardening'),
    Category(id: 11, name: 'Bamboo'),
    Category(id: 12, name: 'Natural Sweetener'),
    Category(id: 13, name: 'Pooja Needs'),
  ];

  final subcategories = [
    const Subcategory(
      id: 0,
      name: 'Pistachio',
      category: Category(id: 0, name: 'Dry Fruits'),
    ),
  ];
}
