import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/presentation/product/explore_product_card.dart';
import 'package:flutter/material.dart';

class ProductGridList extends StatelessWidget {
  final List<Product> products;
  const ProductGridList(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.53,
        crossAxisSpacing: 24,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return ExploreProductCard(
          products[index],
        );
      },
      itemCount: products.length,
    );
  }
}
