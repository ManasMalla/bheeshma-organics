import 'dart:math';

import 'package:bheeshmaorganics/data/entitites/advertisements.dart';
import 'package:bheeshmaorganics/data/providers/advertisement_provider.dart';
import 'package:bheeshmaorganics/data/providers/category_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/home/advertising_card.dart';
import 'package:bheeshmaorganics/presentation/product/product_list_grid.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Function onShowExplorePage;
  const HomePage({
    super.key,
    required this.onShowExplorePage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isCategoriesExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<AdvertisementProvider>(
        builder: (context, advertisementProvider, _) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // AdvertisingCard(
            //   advertisements: advertisementProvider.advertisement,
            // ),
            SizedBox(
              height: 16,
            ),
            CarouselSlider.builder(
              itemCount: advertisementProvider.imageAd.length,
              itemBuilder: (context, index, _) {
                final advertisement = advertisementProvider.imageAd[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        advertisement,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 2,
                viewportFraction: 0.8,
                autoPlay: true,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${FirebaseAuth.instance.currentUser?.displayName == "" ? "User" : FirebaseAuth.instance.currentUser?.displayName?.split(" ").first ?? "User"}!",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "What's on your mind today'?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, _) {
                      return GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: categoryProvider.categories
                            .take(isCategoriesExpanded ? 200 : 6)
                            .map((e) => InkWell(
                                  onTap: () {
                                    categoryProvider.openSpecificIndexInExplore(
                                        categoryProvider.categories.indexOf(e));
                                    widget.onShowExplorePage();
                                  },
                                  child: Container(
                                      alignment: Alignment.bottomLeft,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        color: getThemedColor(
                                                context,
                                                const Color(0xFFD4E28D),
                                                Color.fromARGB(255, 54, 57, 46))
                                            .withOpacity(Random().nextDouble()),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Opacity(
                                              opacity: 0.3,
                                              child: Icon(Icons.category)),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            e.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ],
                                      )),
                                ))
                            .toList(),
                      );
                    }),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isCategoriesExpanded = !isCategoriesExpanded;
                            });
                          },
                          child: Text(
                            isCategoriesExpanded
                                ? "Show Less"
                                : "Show More Categories",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Today's pick",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Nourish your day with Bheeshma Natural products",
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
            ),
          ],
        ),
      );
    });
  }
}
