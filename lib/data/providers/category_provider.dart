import 'package:bheeshmaorganics/data/entitites/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = const [
    // Category(id: 0, name: 'Dry Fruits'),
    // Category(id: 1, name: 'Herbals'),
    // Category(id: 2, name: 'Grains & Pulses'),
    // Category(id: 3, name: 'Spices'),
    // Category(id: 4, name: 'Cold Pressed Oils'),
    // Category(id: 5, name: 'Millets'),
    // Category(id: 6, name: 'Hair care'),
    // Category(id: 7, name: 'Body care'),
    // Category(id: 8, name: 'Oral care'),
    // Category(id: 9, name: 'Ice creams'),
    // Category(id: 10, name: 'Gardening'),
    // Category(id: 11, name: 'Bamboo'),
    // Category(id: 12, name: 'Natural Sweetener'),
    // Category(id: 13, name: 'Pooja Needs'),
  ];

  List<Subcategory> subcategories = [
    // const Subcategory(
    //   id: 0,
    //   name: 'Pistachio',
    //   category: Category(id: 0, name: 'Dry Fruits'),
    // ),
  ];

  var initialCategoryIndex = 0;

  openSpecificIndexInExplore(int index){
    initialCategoryIndex = index;
    notifyListeners();
  }

  fetchCategories() async {
    await FirebaseFirestore.instance.collection('category').get().then((value) {
      categories = value.docs.map((element) {
        final categoryData = element.data();
        return Category(id: categoryData['id'], name: categoryData['name']);
      }).toList();
      notifyListeners();
    });
  }

  fetchSubcategories() async {
    await FirebaseFirestore.instance
        .collection('subcategory')
        .get()
        .then((value) {
      subcategories = value.docs.map((element) {
        final categoryData = element.data();
        return Subcategory(
            id: categoryData['id'],
            name: categoryData['name'],
            category: categories
                .where((element) => element.id == categoryData['category'])
                .first);
      }).toList();
      notifyListeners();
    });
  }
}
