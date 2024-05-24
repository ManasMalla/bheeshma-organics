import 'package:bheeshmaorganics/data/entitites/category.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';

class Product {
  final String docId;
  final int id;
  final String name;
  final List<QuantityInfo> price;
  final String cover;
  final Category category;
  final Subcategory? subcategory;
  final String image;
  final String description;
  const Product({
    required this.docId,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.cover,
    required this.category,
    this.subcategory,
    required this.description,
  });

  List<QuantityInfo> get discountedPrices {
    return price
        .map((product) => QuantityInfo(
              quantity: product.quantity,
              price: product.price - product.discount,
              stock: product.stock,
              discount: product.discount,
            ))
        .toList();
  }

  Product copyWith({required List<QuantityInfo> price}) {
    return Product(
      docId: docId,
      id: id,
      name: name,
      price: price,
      image: image,
      cover: cover,
      category: category,
      subcategory: subcategory,
      description: description,
    );
  }
}

class QuantityInfo {
  final String quantity;
  final double price;
  final int stock;
  final int discount;
  const QuantityInfo({
    required this.quantity,
    required this.price,
    required this.stock,
    required this.discount,
  });

  QuantityInfo copyWith({required int stock}) {
    return QuantityInfo(
      quantity: quantity,
      price: price,
      stock: stock,
      discount: discount,
    );
  }
}
