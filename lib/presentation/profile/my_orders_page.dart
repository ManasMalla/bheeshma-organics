import 'package:bheeshmaorganics/data/providers/order_provider.dart';
import 'package:bheeshmaorganics/presentation/order/order_card.dart';
import 'package:bheeshmaorganics/presentation/profile/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Orders',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Everything natural that you\'ve ever ordererd',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 24,
                ),
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, orderIndex) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(
                                  index: orderIndex,
                                )));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Order #${orderProvider.orders[orderIndex].id + 1}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFF7D005),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Text(
                                      orderProvider.orders[orderIndex].status
                                              .where((element) => element == 7)
                                              .isNotEmpty
                                          ? 'Cancelled'
                                          : orderProvider
                                                  .orders[orderIndex].status
                                                  .where(
                                                      (element) => element != 3)
                                                  .isNotEmpty
                                              ? "In Progress"
                                              : "Delivered",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                DateFormat("EEE, MMM dd").format(
                                    orderProvider.orders[orderIndex].date),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  separatorBuilder: (_, __) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Opacity(
                                          opacity: 0.2, child: Divider()),
                                    );
                                  },
                                  itemCount: orderProvider
                                      .orders[orderIndex].products.length,
                                  itemBuilder: (context, productOrderIndex) {
                                    final orderItem = orderProvider
                                        .orders[orderIndex]
                                        .products[productOrderIndex];

                                    return OrderItemCard(
                                      productName: orderItem.productName,
                                      quantity: orderItem.quantity,
                                      quantityChoice: orderItem.size,
                                      price: orderItem.price,
                                      modifyItemCount: (_) {},
                                      isOrderHistory: true,
                                      isReview: true,
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, _) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Opacity(opacity: 0.2, child: Divider()),
                    );
                  },
                  itemCount: orderProvider.orders.length,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
