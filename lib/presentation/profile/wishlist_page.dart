import 'package:bheeshmaorganics/data/providers/liked_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/product/product_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          Consumer<LikedItemsProvider>(builder: (context, wishlistProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wishlist",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Your list of fresh products you choose to savour later!",
              ),
              const SizedBox(
                height: 24,
              ),
              wishlistProvider.wishlist.isEmpty
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              "assets/images/hungry.svg",
                              colorFilter: ColorFilter.mode(
                                  getThemedColor(
                                      context,
                                      const Color(0x60074014),
                                      const Color(0x60699E81)),
                                  BlendMode.srcIn),
                              width: 170,
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          Text(
                            "Oops!",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "You don't have any items in your wishlist.\nStart by adding items to your wishlist.",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Consumer<ProductProvider>(
                      builder: (context, productProvider, _) {
                      return ProductGridList(
                        productProvider.products
                            .where((element) =>
                                wishlistProvider.wishlist.contains(element.id))
                            .toList(),
                      );
                    }),
            ],
          ),
        );
      }),
    );
  }
}
