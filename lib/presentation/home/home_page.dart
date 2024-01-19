import 'package:bheeshmaorganics/data/entitites/advertisements.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/presentation/home/advertising_card.dart';
import 'package:bheeshmaorganics/presentation/product/product_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  final advertisement = const [
    Advertisement(
      title: 'Amazing Almonds',
      subtitle: 'Rich in vitamin A',
      description:
          'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
      arguments: 3,
    ),
    Advertisement(
      title: 'Pleasing Pistachio',
      subtitle: 'Rich in vitamin E',
      description:
          'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
      arguments: 0,
      cta: "Order Now",
    ),
    Advertisement(
        title: 'Delicious Dried Figs',
        subtitle: 'Rich in vitamin C',
        description:
            'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
        arguments: 1),
    Advertisement(
        title: 'Ravishing Raisins',
        subtitle: 'Rich in vitamin B',
        description:
            'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
        arguments: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AdvertisingCard(
            advertisements: advertisement,
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's pick",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "lorem ipsum dolor amet sit contestuer",
                ),
                const SizedBox(
                  height: 24,
                ),
                Consumer<ProductProvider>(
                    builder: (context, productProvider, _) {
                  return ProductGridList(
                    productProvider.products,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
