import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/liked_provider.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowQuantitySelectionBottomSheet extends StatefulWidget {
  final Product product;
  const ShowQuantitySelectionBottomSheet(this.product, {super.key});

  @override
  State<ShowQuantitySelectionBottomSheet> createState() =>
      _ShowQuantitySelectionBottomSheetState();
}

class _ShowQuantitySelectionBottomSheetState
    extends State<ShowQuantitySelectionBottomSheet> {
  var quantitySelection = 0;
  @override
  Widget build(BuildContext context) {
    final getThemedWhite = getThemedColor(context, Colors.white, Colors.black);
    final getThemedBlack = getThemedColor(context, Colors.black, Colors.white);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "How much?",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Choose the quantity of the product\nyou want to add to cart",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Wrap(
              children: widget.product.price.map((e) {
                final index = widget.product.price.indexOf(e);
                return FilterChip(
                  label: Text(e.quantity),
                  onSelected: e.stock == 0
                      ? null
                      : (_) {
                          setState(() {
                            quantitySelection = index;
                          });
                        },
                  selected: quantitySelection == index,
                );
              }).toList(),
            ),
            const SizedBox(
              height: 24,
            ),
            MaterialButton(
              disabledColor: Theme.of(context).colorScheme.error,
              color: getThemedBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              onPressed: widget.product.price[quantitySelection].stock == 0
                  ? null
                  : () {
                      final cartItem = CartItem(
                        productId: widget.product.id,
                        quantity: 1,
                        size: quantitySelection,
                      );

                      Provider.of<LikedItemsProvider>(context, listen: false)
                          .removeProductFromLikedItems(
                        widget.product.id,
                        ScaffoldMessenger.of(context),
                      );
                      Provider.of<CartProvider>(context, listen: false)
                          .addProductToCart(
                        cartItem,
                        ScaffoldMessenger.of(context),
                      );
                      Navigator.of(context).pop();
                    },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FeatherIcons.shoppingBag,
                    color: widget.product.price[quantitySelection].stock == 0
                        ? Theme.of(context).colorScheme.onError
                        : getThemedWhite,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Add to cart',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              widget.product.price[quantitySelection].stock == 0
                                  ? Theme.of(context).colorScheme.onError
                                  : getThemedWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showQuantitySelectionBottomSheet(
    BuildContext context, Product product) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return ShowQuantitySelectionBottomSheet(product);
    },
  );
}
