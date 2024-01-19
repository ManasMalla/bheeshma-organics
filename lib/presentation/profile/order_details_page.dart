// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bheeshmaorganics/data/entitites/payment_method.dart';
import 'package:bheeshmaorganics/data/providers/order_provider.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/presentation/order/invoice.dart';
import 'package:bheeshmaorganics/presentation/order/order_card.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final int index;

  const OrderDetailScreen({super.key, required this.index});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          toolbarHeight: kToolbarHeight + 30,
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              'Order #${orderProvider.orders[widget.index].id}'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(letterSpacing: 5),
            ),
            Text(
              DateFormat("EEE, MMM dd")
                  .format(
                    orderProvider.orders[widget.index].date,
                  )
                  .toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, letterSpacing: 2.5),
            )
          ]),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InvoicePage(
                          orderProvider.orders[widget.index],
                        )));
              },
              icon: Icon(
                FeatherIcons.downloadCloud,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.value();
          },
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                final orderStatus = orderProvider.orders[widget.index].status;
                return Container(
                  width: double.infinity,
                  color: getThemedColor(context, const Color(0xFFEFE8CC),
                      const Color.fromARGB(255, 46, 45, 43)),
                  child: orderStatus.where((element) => element != 7).isEmpty
                      ? Stepper(
                          physics: NeverScrollableScrollPhysics(),
                          steps: [
                            Step(
                                title: const Text(
                                  'Order Placed',
                                ),
                                content: const SizedBox(height: 0),
                                subtitle: Text(
                                  DateFormat("EEE, MMM dd")
                                      .format(DateTime.now()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: const Color.fromARGB(
                                              255, 192, 183, 147),
                                          letterSpacing: 2.5),
                                ),
                                isActive: orderStatus.contains(0),
                                state: !orderStatus.contains(0)
                                    ? StepState.complete
                                    : StepState.indexed),
                            const Step(
                                title: Text(
                                  'Order Cancelled',
                                ),
                                content: SizedBox(),
                                // isActive: false,
                                label: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                state: StepState.error),
                          ],
                          controlsBuilder: (context, _) {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          },
                        )
                      : Stepper(
                          physics: NeverScrollableScrollPhysics(),
                          currentStep: 0,
                          steps: [
                            Step(
                                title: const Text(
                                  'Order Placed',
                                ),
                                content: const SizedBox(height: 0),
                                subtitle: Text(
                                  DateFormat("EEE, MMM dd")
                                      .format(DateTime.now()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: const Color.fromARGB(
                                              255, 192, 183, 147),
                                          letterSpacing: 2.5),
                                ),
                                isActive: orderStatus.contains(0),
                                state: !orderStatus.contains(0)
                                    ? StepState.complete
                                    : StepState.indexed),
                            Step(
                                title: const Text(
                                  'Order Accepted',
                                ),
                                content: const SizedBox(),
                                isActive: orderStatus.contains(1),
                                state: orderStatus.contains(1)
                                    ? StepState.complete
                                    : StepState.indexed),
                            Step(
                                title: const Text(
                                  'Order Shipped',
                                ),
                                content: const SizedBox(),
                                isActive: orderStatus.contains(2),
                                state: orderStatus.contains(2)
                                    ? StepState.complete
                                    : StepState.indexed),
                            Step(
                                title: const Text(
                                  'Order Delivered',
                                ),
                                content: const SizedBox(),
                                isActive: orderStatus.contains(3),
                                state: orderStatus.contains(3)
                                    ? StepState.complete
                                    : StepState.indexed),
                          ],
                          controlsBuilder: (context, _) {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          },
                        ),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (_, __) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Opacity(opacity: 0.2, child: Divider()),
                            );
                          },
                          itemCount: orderProvider
                              .orders[widget.index].products.length,
                          itemBuilder: (context, productOrderIndex) {
                            final orderItem = orderProvider.orders[widget.index]
                                .products[productOrderIndex];
                            return OrderItemCard(
                              productName: orderItem.productName,
                              price: orderItem.price,
                              quantity: orderItem.quantity,
                              quantityChoice: orderItem.size,
                              modifyItemCount: (_) {},
                              isReview: true,
                            );
                          }),
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
                          'Total'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    letterSpacing: 2.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Rs. ${orderProvider.orders[widget.index].products.map((e) => (e.price) * ((e.quantity))).reduce(
                                (value, element) => value + element,
                              )}',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: orderProvider.orders[widget.index].coupon == null
                          ? 0
                          : 16,
                    ),
                    Builder(builder: (context) {
                      final coupon = orderProvider.orders[widget.index].coupon;
                      return coupon == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                Text(
                                  'Discount '.toUpperCase(),
                                ),
                                Text(
                                  '(${coupon.code} applied)'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                      ),
                                ),
                                const Spacer(),
                                Text(
                                  '- Rs. ${coupon.type == DiscountType.percentage ? (coupon.discount * 0.01 * orderProvider.orders[widget.index].products.map((e) => (e.price) * ((e.quantity))).reduce(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    letterSpacing: 5),
                          ),
                          Text(
                            'Rs. ${orderProvider.orders[widget.index].products.map((e) => (e.price) * ((e.quantity))).reduce(
                                  (value, element) => value + element,
                                ) - (orderProvider.orders[widget.index].coupon == null ? 0 : orderProvider.orders[widget.index].coupon!.type == DiscountType.percentage ? (orderProvider.orders[widget.index].coupon!.discount * 0.01 * orderProvider.orders[widget.index].products.map((e) => (e.price) * ((e.quantity))).reduce(
                                  (value, element) => value + element,
                                )) : orderProvider.orders[widget.index].coupon!.discount) + 100.00}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Payment Information'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        SvgPicture.network(
                          'https://upload.wikimedia.org/wikipedia/commons/a/a4/Mastercard_2019_logo.svg',
                          height: 36,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Builder(builder: (context) {
                          final paymentData = orderProvider.orders[widget.index]
                              .paymentMethod as CardPaymentMethod;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(paymentData.name),
                              Text("**** **** **** ${paymentData.last4}"),
                              Text(
                                  "${paymentData.cardIssuer} ${paymentData.cardType} Card"),
                            ],
                          );
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Deliver to'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Builder(builder: (context) {
                      final shippingAddress =
                          orderProvider.orders[widget.index].shippingAddress;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shippingAddress.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "${shippingAddress.doorNumber}\n${shippingAddress.building}\n${shippingAddress.landmark}\n${shippingAddress.street}, ${shippingAddress.city}\n${shippingAddress.state} - ${shippingAddress.pincode}",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w300),
                          ),
                          Text(
                              "Contact Number: ${shippingAddress.phoneNumber}"),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    FilledButton(
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {},
                      child: Text(
                        'Cancel Order'.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
        ),
      );
    });
  }
}
