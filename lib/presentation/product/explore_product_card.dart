import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/liked_provider.dart';
import 'package:bheeshmaorganics/data/utils/cart_utll.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/product/modify_cart_sheet.dart';
import 'package:bheeshmaorganics/presentation/product/show_quantity_selection_sheet.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreProductCard extends StatelessWidget {
  final Product product;
  const ExploreProductCard(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: product.id);
      },
      child:
          Consumer<LikedItemsProvider>(builder: (context, wishlistProvider, _) {
        return Consumer<CartProvider>(builder: (context, cartProvider, _) {
          final existInCart =
              doesProductExistInCart(cartProvider.cart, product, -1);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  product.price.first.discount > 0
                      ? Text(
                          '₹${product.discountedPrices.first.price.toInt()}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF699E81),
                                  ),
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                  SizedBox(
                    width: product.price.first.discount > 0 ? 6 : 0,
                  ),
                  Text(
                    '₹${product.price.first.price.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: product.price.first.discount > 0
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF699E81).withOpacity(
                            product.price.first.discount <= 0 ? 1 : 0.6),
                        decorationColor:
                            const Color(0xFF699E81).withOpacity(0.7)),
                  ),
                  product.price.first.discount > 0
                      ? Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '(${((product.price.first.discount * 100) / product.price.first.price).round()}${'%'} off)',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                ],
              ),
              Text(
                product.description,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  MaterialButton(
                    color: existInCart
                        ? const Color(0xFF006D3B)
                        : getThemedColor(context, Colors.black, Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    onPressed: () {
                      if (existInCart) {
                        showModifyCartBottomSheet(
                            context,
                            product,
                            cartProvider.cart
                                .where((element) =>
                                    element.productId == product.id)
                                .toList());
                      } else {
                        showQuantitySelectionBottomSheet(context, product);
                      }
                    },
                    child: existInCart
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                FeatherIcons.shoppingBag,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Modify',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Text(
                            'Add to cart',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: getThemedColor(
                                      context,
                                      Colors.white,
                                      Colors.black,
                                    ),
                                    fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(
                    width: 8,
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
                                color: getThemedColor(
                                    context, Colors.black, Colors.white),
                                width: 1.3,
                              ),
                      ),
                      onPressed: () {
                        if (wishlistProvider.wishlist.contains(product.id)) {
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
          );
        });
      }),
    );
  }
}
