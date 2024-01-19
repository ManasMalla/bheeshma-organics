import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
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
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            Text(
              '${product.price.keys.toList()[quantityChoice]} Pack'
                  .toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white54),
            ),
          ],
        ),
        const Spacer(),
        quantity == 0
            ? const SizedBox()
            : Container(
                decoration: BoxDecoration(
                    color: isOrderHistory ? null : const Color(0xFF487D60),
                    borderRadius: BorderRadius.circular(32),
                    border: isOrderHistory
                        ? Border.all(
                            color: getThemedColor(
                                context, Colors.black, Colors.white))
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
                        ? InkWell(
                            onTap: () {
                              modifyItemCount(-1);
                            },
                            child: const Icon(
                              FeatherIcons.minusCircle,
                              size: 18,
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
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    !isReview
                        ? InkWell(
                            onTap: () {
                              modifyItemCount(1);
                            },
                            child: const Icon(
                              FeatherIcons.plusCircle,
                              size: 18,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
        quantity == 0
            ? const SizedBox()
            : const SizedBox(
                width: 12,
              ),
        isOrderHistory
            ? SizedBox()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 24,
                ),
                child: Text(
                  "₹${product.discountedPrices.entries.toList()[quantityChoice].value * (quantity == 0 ? 1 : quantity)}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF487D60),
                      ),
                ),
              ),
        quantity == 0
            ? const SizedBox(
                width: 12,
              )
            : const SizedBox(),
        quantity == 0
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
    );
  }
}
