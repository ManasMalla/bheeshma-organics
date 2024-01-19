import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/liked_provider.dart';
import 'package:bheeshmaorganics/data/utils/cart_utll.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/product/show_quantity_selection_sheet.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final getThemedWhite = getThemedColor(context, Colors.white, Colors.black);
    final getThemedBlack = getThemedColor(context, Colors.black, Colors.white);
    final productPrices = product.discountedPrices;
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      final existInCart =
          doesProductExistInCart(cartProvider.cart, product, -1);
      return Consumer<LikedItemsProvider>(
          builder: (context, wishlistProvider, _) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/product', arguments: product.id);
          },
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        "Rs. ${productPrices.entries.first.value}",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                      ),
                      Text(
                        "/${productPrices.entries.first.key}",
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: existInCart
                            ? const Color(0xFF006D3B)
                            : getThemedBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 24),
                        onPressed: () {
                          if (existInCart) {
                            //TODO MODIFY CART
                            return;
                          } else {
                            showQuantitySelectionBottomSheet(context, product);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FeatherIcons.shoppingBag,
                              color:
                                  existInCart ? Colors.white : getThemedWhite,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              (existInCart ? 'Modify Cart' : 'Add to cart')
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: existInCart
                                          ? Colors.white
                                          : getThemedWhite,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: 40,
                        child: MaterialButton(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: wishlistProvider.wishlist.contains(product.id)
                                ? BorderSide.none
                                : BorderSide(
                                    color: getThemedBlack,
                                    width: 1.3,
                                  ),
                          ),
                          onPressed: () {
                            if (wishlistProvider.wishlist
                                .contains(product.id)) {
                              wishlistProvider.removeProductFromLikedItems(
                                product.id,
                                ScaffoldMessenger.of(context),
                              );
                            } else {
                              wishlistProvider.addProductToLikedItems(
                                product.id,
                                ScaffoldMessenger.of(context),
                              );
                            }
                          },
                          color: wishlistProvider.wishlist.contains(product.id)
                              ? Colors.red.shade800
                              : null,
                          child: Icon(
                            wishlistProvider.wishlist.contains(product.id)
                                ? Icons.favorite_rounded
                                : FeatherIcons.heart,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              const SizedBox(
                width: 24,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
