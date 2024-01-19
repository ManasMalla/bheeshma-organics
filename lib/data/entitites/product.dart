import 'package:bheeshmaorganics/data/entitites/category.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';

class Product {
  final int id;
  final String name;
  final Map<String, double> price;
  final String cover;
  final Category category;
  final Subcategory? subcategory;
  final String image;
  final String description;
  final int discount;
  final DiscountType discountType;
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.cover,
    required this.category,
    this.subcategory,
    required this.description,
    required this.discount,
    required this.discountType,
  });

  Map<String, double> get discountedPrices {
    return price.map((key, e) => MapEntry(
        key,
        discountType == DiscountType.percentage
            ? e - ((e * discount) / 100).ceil()
            : e - discount));
  }
}
