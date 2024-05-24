import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/presentation/basket/basket_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BasketBottomSheet extends StatefulWidget {
  const BasketBottomSheet({
    super.key,
  });

  @override
  State<BasketBottomSheet> createState() => _BasketBottomSheetState();
}

class _BasketBottomSheetState extends State<BasketBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    FeatherIcons.arrowLeft,
                  ),
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 16,
                ),
                cartProvider.cart.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              "assets/images/hungry.svg",
                              colorFilter: const ColorFilter.mode(
                                  Color(0x60074014), BlendMode.srcIn),
                              width: 170,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "I'm hungry",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "You don't have any items in your bag.\nStart by adding items to your cart.",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Basket",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ListView.separated(
                            itemBuilder: (context, index) => BasketItem(
                              productProvider.products
                                  .where((element) =>
                                      cartProvider.cart[index].productId ==
                                      element.id)
                                  .first,
                              quantityChoice: cartProvider.cart[index].size,
                              quantity: cartProvider.cart[index].quantity,
                              modifyItemCount: (delta) {
                                cartProvider.modifyProduct(index, delta);
                              },
                            ),
                            separatorBuilder: (context, _) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Divider(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            itemCount: cartProvider.cart.length,
                            shrinkWrap: true,
                            primary: false,
                          ),
                          Row(
                            children: [
                              Text(
                                'TOTAL',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                "₹ ${cartProvider.calculateTotalPrice(products: productProvider.products)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF699E81),
                          ),
                          onPressed: () {
                            if (cartProvider.cart.isEmpty) {
                              Navigator.of(context).pop();
                              return;
                            }
                            Navigator.of(context).pushNamed('/review');
                          },
                          child: Text(
                            cartProvider.cart.isEmpty
                                ? 'Shop Items'
                                : 'CONFIRM ORDER',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF699E81),
                                ),
                          ),
                        ),
                      ),
                    ),
                    cartProvider.cart.isEmpty
                        ? const SizedBox(
                            width: 24,
                          )
                        : const SizedBox(),
                    cartProvider.cart.isEmpty
                        ? Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/wishlist');
                                },
                                child: Text(
                                  'View Wishlist',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
