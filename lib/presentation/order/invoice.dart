import 'package:bheeshmaorganics/data/entitites/order.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:bheeshmaorganics/presentation/order/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvoicePage extends StatelessWidget {
  final Order order;
  const InvoicePage(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
          const SizedBox(
            height: 48,
          ),
          SvgPicture.asset(
            'assets/images/bheeshma-naturals.svg',
            colorFilter: Theme.of(context).brightness == Brightness.dark
                ? ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  )
                : null,
          ),
          const SizedBox(
            height: 16,
          ),
          Text('Never before price - Ever after quality'.toUpperCase()),
          const SizedBox(
            height: 24,
          ),
          Text(
            'INVOICE',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text('Time'.toUpperCase()),
              const Spacer(),
              const Text('11:00 PM'),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text('Date'.toUpperCase()),
              const Spacer(),
              const Text('13-01-2024'),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text('GSTIN'.toUpperCase()),
              const Spacer(),
              const Text('APLM1234567890123456PAN'),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),
          ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(
                    height: 16,
                  ),
              itemCount: order.products.length,
              itemBuilder: (context, productOrderIndex) {
                final orderItem = order.products[productOrderIndex];
                return OrderItemCard(
                  productName: orderItem.productName,
                  price: orderItem.price,
                  quantity: orderItem.quantity,
                  quantityChoice: orderItem.size,
                  modifyItemCount: (_) {},
                  isReview: true,
                );
              }),
          const SizedBox(
            height: 16,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total'.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Rs. ${order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                      (value, element) => value + element,
                    )}',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Builder(builder: (context) {
            final coupon = order.coupon;
            return coupon == null
                ? const SizedBox()
                : Row(
                    children: [
                      Text(
                        'Discount '.toUpperCase(),
                      ),
                      Text(
                        '(${coupon.code} applied)'.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.4),
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '- Rs. ${coupon.type == DiscountType.percentage ? (coupon.discount * 0.01 * order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                              (value, element) => value + element,
                            )).toStringAsFixed(2) : coupon.discount.toStringAsFixed(2)}',
                      ),
                    ],
                  );
          }),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Charge'.toUpperCase(),
              ),
              const Text(
                'Rs. 100.00',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total'.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5),
              ),
              Text(
                'Rs. ${order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                      (value, element) => value + element,
                    ) - (order.coupon == null ? 0 : order.coupon!.type == DiscountType.percentage ? (order.coupon!.discount * 0.01 * order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                      (value, element) => value + element,
                    )) : order.coupon!.discount) + 100.00}',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
        ]),
      ),
    );
  }
}
