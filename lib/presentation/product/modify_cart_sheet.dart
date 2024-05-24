import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/presentation/basket/basket_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyCartBottomSheet extends StatefulWidget {
  final Product product;
  const ModifyCartBottomSheet(this.product, {super.key});

  @override
  State<ModifyCartBottomSheet> createState() => _ModifyCartBottomSheetState();
}

class _ModifyCartBottomSheetState extends State<ModifyCartBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      final cart = cartProvider.cart
          .where((element) => element.productId == widget.product.id)
          .toList();
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modify Cart',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(
              height: 24,
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return BasketItem(
                  widget.product,
                  quantity: cart[index].quantity,
                  quantityChoice: cart[index].size,
                  modifyItemCount: (delta) {
                    cartProvider.modifyProduct(
                        cartProvider.cart.indexOf(cart[index]), delta);
                    setState(() {});
                  },
                );
              },
              separatorBuilder: (context, _) => const SizedBox(
                height: 12,
              ),
              itemCount: cart.length,
              shrinkWrap: true,
              primary: false,
            ),
            // const SizedBox(
            //   height: 24,
            // ),
            // cart.length == widget.product.price.length
            //     ? const SizedBox()
            //     : Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'You might want to add',
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .headlineSmall
            //                 ?.copyWith(
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.white),
            //           ),
            //           const SizedBox(
            //             height: 24,
            //           ),
            //           ListView.separated(
            //             padding: EdgeInsets.zero,
            //             itemBuilder: (context, index) {
            //               final sizesList = List.generate(
            //                   widget.product.price.length, (index) => index);
            //               for (var item in cart) {
            //                 sizesList.remove(item.size);
            //               }
            //               return BasketItem(
            //                 widget.product,
            //                 quantity: 0,
            //                 quantityChoice: sizesList[index],
            //                 modifyItemCount: (delta) {
            //                   cartProvider.addProductToCart(
            //                     CartItem(
            //                         productId: widget.product.id,
            //                         quantity: delta,
            //                         size: sizesList[index]),
            //                     ScaffoldMessenger.of(context),
            //                   );
            //                   setState(() {});
            //                 },
            //               );
            //             },
            //             separatorBuilder: (context, _) => const SizedBox(
            //               height: 12,
            //             ),
            //             itemCount: widget.product.price.length - cart.length,
            //             shrinkWrap: true,
            //             primary: false,
            //           )
            //         ],
            //       ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF699E81),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FeatherIcons.edit,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Modify',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF699E81),
                          ),
                    ),
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

void showModifyCartBottomSheet(
    BuildContext context, Product product, List<CartItem> cart) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF699E81),
      builder: (context) {
        return ModifyCartBottomSheet(product);
      });
}
