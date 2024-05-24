import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class BasketItem extends StatelessWidget {
  final Product product;
  final int quantityChoice;
  final int quantity;
  final bool isReview;
  final bool isOrderHistory;
  final Function(int) modifyItemCount;
  const BasketItem(
    this.product, {
    super.key,
    required this.quantity,
    required this.quantityChoice,
    this.isReview = false,
    this.isOrderHistory = false,
    required this.modifyItemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: product.price[quantityChoice].stock == 0 ? 0.5 : 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.contains("|")
                        ? product.name.split(" | ").first
                        : product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                  ),
                  product.name.contains("|")
                      ? Text(
                          product.name.split(" | ").skip(1).join(" | "),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        )
                      : SizedBox(),
                  Text(
                    '${product.price[quantityChoice].quantity} Pack'
                        .toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white54),
                  ),
                  // isOrderHistory
                  //     ? const SizedBox()
                  //     : Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(32),
                  //         ),
                  //         padding: const EdgeInsets.symmetric(
                  //           vertical: 6,
                  //           horizontal: 24,
                  //         ),
                  //         child: Text(
                  //           "₹${product.discountedPrices[quantityChoice].price * (quantity == 0 ? 1 : quantity)}",
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .titleLarge
                  //               ?.copyWith(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: const Color(0xFF487D60),
                  //               ),
                  //         ),
                  //       ),
                  isReview
                      ? SizedBox()
                      : Text(
                          "₹${product.discountedPrices[quantityChoice].price * (quantity == 0 ? 1 : quantity)}",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                        ),
                ],
              ),
            ),
          ),
          quantity == 0 || product.price[quantityChoice].stock == 0 || isReview
              ? const SizedBox()
              : QuantityChipForBasketItem(
                  isOrderHistory: isOrderHistory,
                  isReview: isReview,
                  modifyItemCount: modifyItemCount,
                  quantity: quantity,
                  product: product,
                  quantityChoice: quantityChoice),
          quantity == 0
              ? const SizedBox()
              : const SizedBox(
                  width: 12,
                ),
          isOrderHistory
              ? const SizedBox()
              : !isReview
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        quantity == 0 ||
                                product.price[quantityChoice].stock == 0
                            ? const SizedBox()
                            : QuantityChipForBasketItem(
                                isOrderHistory: isOrderHistory,
                                isReview: isReview,
                                modifyItemCount: modifyItemCount,
                                quantity: quantity,
                                product: product,
                                quantityChoice: quantityChoice),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 24,
                          ),
                          child: Text(
                            "₹${product.discountedPrices[quantityChoice].price * (quantity == 0 ? 1 : quantity)}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF487D60),
                                ),
                          ),
                        ),
                      ],
                    ),
          quantity == 0 && product.price[quantityChoice].stock != 0
              ? const SizedBox(
                  width: 12,
                )
              : const SizedBox(),
          quantity == 0 && product.price[quantityChoice].stock != 0
              ? FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF487D60),
                  ),
                  onPressed: () {
                    modifyItemCount(1);
                  },
                  child: Text(
                    'ADD',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class QuantityChipForBasketItem extends StatelessWidget {
  const QuantityChipForBasketItem({
    super.key,
    required this.isOrderHistory,
    required this.isReview,
    required this.modifyItemCount,
    required this.quantity,
    required this.product,
    required this.quantityChoice,
  });

  final bool isOrderHistory;
  final bool isReview;
  final Function(int p1) modifyItemCount;
  final int quantity;
  final Product product;
  final int quantityChoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isOrderHistory ? null : const Color(0xFF487D60),
          borderRadius: BorderRadius.circular(32),
          border: isOrderHistory
              ? Border.all(
                  color: getThemedColor(context, Colors.black, Colors.white))
              : null),
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isReview ? 8 : 0,
          ),
          !isReview
              ? IconButton(
                  onPressed: () {
                    modifyItemCount(-1);
                  },
                  icon: const Icon(
                    FeatherIcons.minusCircle,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
          SizedBox(
            width: isReview ? 5 : 12,
          ),
          Text(
            quantity.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            width: 12,
          ),
          !isReview
              ? IconButton(
                  onPressed: () {
                    if (quantity + 1 > product.price[quantityChoice].stock) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(BheeshmaSnackbar(
                        title: 'Ooops!',
                        message:
                            'Only ${product.price[quantityChoice].stock} items are available',
                        contentType: ContentType.failure,
                      ));
                      return;
                    }
                    modifyItemCount(1);
                  },
                  icon: const Icon(
                    FeatherIcons.plusCircle,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
