// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:math';

import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/payment_method.dart';
import 'package:bheeshmaorganics/data/providers/address_provider.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/order_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:bheeshmaorganics/data/utils/secrets.dart';
import 'package:bheeshmaorganics/presentation/basket/basket_sheet.dart';
import 'package:bheeshmaorganics/presentation/order/invoice.dart';
import 'package:bheeshmaorganics/presentation/order/order_card.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
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
    return Consumer<ProductProvider>(builder: (context, productProvider, _) {
      return Consumer<CartProvider>(builder: (context, cartProvider, _) {
        return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
          return Scaffold(
            floatingActionButton: orderProvider.orders[widget.index].status
                    .where((element) => element == 7)
                    .isNotEmpty
                ? FilledButton(
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () async {
                      if (cartProvider.cart.isEmpty) {
                        print("EMPTY");
                        orderProvider.orders[widget.index].products
                            .forEach((orderElement) async {
                          print(
                              "orderElement: ${orderElement.productName}\n====================");
                          var product = productProvider.products
                              .where((element) =>
                                  element.name == orderElement.productName)
                              .firstOrNull;

                          print("product: $product");
                          var cartItem = product == null
                              ? null
                              : CartItem(
                                  productId: product.id,
                                  quantity: orderElement.quantity,
                                  size: product.price.indexWhere((element) =>
                                      element.quantity == orderElement.size));
                          if (cartItem != null) {
                            await cartProvider.addProductToCart(
                                cartItem, ScaffoldMessenger.of(context));
                          }
                        });
                      }
                      Navigator.of(context)
                          .popUntil((route) => route.settings.name == "/home");
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF699E81),
                          context: context,
                          builder: (context) {
                            return const BasketBottomSheet();
                          });
                    },
                    child: Text(
                      'Retry Order',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  )
                : orderProvider.orders[widget.index].status
                        .where((element) => element > 1)
                        .isNotEmpty
                    ? FilledButton(
                        onPressed: () async {
                          //Add products to the
                          Navigator.of(context).popUntil(
                              (route) => route.settings.name == "/home");
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: const Color(0xFF699E81),
                              context: context,
                              builder: (context) {
                                return const BasketBottomSheet();
                              });
                        },
                        child: Text('Rebuy Order',
                            style: Theme.of(context).textTheme.labelLarge),
                      )
                    : FilledButton(
                        style:
                            FilledButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Cancel Order?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to cancel this order?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                            'No, I\'ve changed my mind')),
                                    FilledButton(
                                      onPressed: () async {
                                        await cancelOrder(orderProvider);
                                      },
                                      child: const Text("Yes, cancel order"),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Cancel Order',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              toolbarHeight: kToolbarHeight + 30,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Order #${orderProvider.orders[widget.index].id + 1}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(letterSpacing: 5),
                    ),
                    Text(
                      DateFormat("EEE, MMM dd").format(
                        orderProvider.orders[widget.index].date,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey, letterSpacing: 2.5),
                    )
                  ]),
              actions: [
                orderProvider.orders[widget.index].status
                        .where((element) => element == 7)
                        .isNotEmpty
                    ? const SizedBox()
                    : IconButton(
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
                return orderProvider.fetchOrders(
                    Provider.of<AddressProvider>(context, listen: false)
                        .addresses);
              },
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                      key: Key(Random.secure().nextDouble().toString()),
                      builder: (context) {
                        final orderStatus =
                            orderProvider.orders[widget.index].status;
                        return Container(
                          width: double.infinity,
                          color: getThemedColor(
                              context,
                              const Color(0xFFEFE8CC),
                              const Color.fromARGB(255, 46, 45, 43)),
                          child: orderStatus
                                  .where((element) => element != 7)
                                  .isEmpty
                              ? Stepper(
                                  key: Key(
                                      Random.secure().nextDouble().toString()),
                                  physics: const NeverScrollableScrollPhysics(),
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
                                  key: Key(
                                      Random.secure().nextDouble().toString()),
                                  physics: const NeverScrollableScrollPhysics(),
                                  currentStep: 0,
                                  steps: [
                                    Step(
                                        title: Text(
                                          'Order Placed',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        content: const SizedBox(height: 0),
                                        // subtitle: Text(
                                        //   DateFormat("EEE, MMM dd")
                                        //       .format(DateTime.now()),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .titleSmall
                                        //       ?.copyWith(
                                        //           color: const Color.fromARGB(
                                        //               255, 192, 183, 147),
                                        //           letterSpacing: 2.5),
                                        // ),
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
                                        subtitle: orderStatus.contains(2)
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ...(orderProvider
                                                      .orders[widget.index]
                                                      .trackingIds
                                                      .indexed
                                                      .where((element) =>
                                                          (element.$2["text"]
                                                                  ?.isNotEmpty ??
                                                              true) &&
                                                          orderStatus[
                                                                  element.$1] ==
                                                              2)
                                                      .map((e) => Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      "Tracking ID: ${e.$2["text"]}"),
                                                                  Text(
                                                                      "Carrier: ${e.$2["partner"]}"),
                                                                  Text(orderProvider
                                                                      .orders[widget
                                                                          .index]
                                                                      .products[
                                                                          e.$1]
                                                                      .productName),
                                                                  Divider()
                                                                ],
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  Clipboard.setData(
                                                                      ClipboardData(
                                                                          text: e.$2["text"] ??
                                                                              ""));
                                                                },
                                                                icon: Icon(
                                                                    Icons.copy),
                                                              ),
                                                            ],
                                                          ))
                                                      .toList())
                                                ],
                                              )
                                            : SizedBox(),
                                        content: SizedBox(),
                                        isActive: orderStatus.contains(2),
                                        state: orderStatus.contains(2)
                                            ? StepState.complete
                                            : StepState.indexed),
                                    Step(
                                        title: const Text(
                                          'Order Delivered',
                                        ),
                                        subtitle: orderStatus.contains(3)
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ...(orderProvider
                                                      .orders[widget.index]
                                                      .trackingIds
                                                      .indexed
                                                      .where((element) =>
                                                          (element.$2["text"]
                                                                  ?.isNotEmpty ??
                                                              true) &&
                                                          orderStatus[
                                                                  element.$1] ==
                                                              3)
                                                      .map((e) => Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      "Tracking ID: ${e.$2["text"]}"),
                                                                  Text(
                                                                      "Carrier: ${e.$2["partner"]}"),
                                                                  Text(orderProvider
                                                                      .orders[widget
                                                                          .index]
                                                                      .products[
                                                                          e.$1]
                                                                      .productName),
                                                                  Divider()
                                                                ],
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  Clipboard.setData(
                                                                      ClipboardData(
                                                                          text: e.$2["text"] ??
                                                                              ""));
                                                                },
                                                                icon: Icon(
                                                                    Icons.copy),
                                                              ),
                                                            ],
                                                          ))
                                                      .toList())
                                                ],
                                              )
                                            : const SizedBox(),
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
                          'Order Information',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  child:
                                      Opacity(opacity: 0.2, child: Divider()),
                                );
                              },
                              itemCount: orderProvider
                                  .orders[widget.index].products.length,
                              itemBuilder: (context, productOrderIndex) {
                                final orderItem = orderProvider
                                    .orders[widget.index]
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
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
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
                          height:
                              orderProvider.orders[widget.index].coupon == null
                                  ? 0
                                  : 16,
                        ),
                        Builder(builder: (context) {
                          final coupon =
                              orderProvider.orders[widget.index].coupon;
                          return coupon == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    const Text(
                                      'Discount ',
                                    ),
                                    Text(
                                      '(${coupon.code} applied)',
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Delivery Charge',
                        //     ),
                        //     const Text(
                        //       'Rs. 100.00',
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        letterSpacing: 5),
                              ),
                              Text(
                                'Rs. ${orderProvider.orders[widget.index].products.map((e) => (e.price) * ((e.quantity))).reduce(
                                      (value, element) => value + element,
                                    ) - (orderProvider.orders[widget.index].coupon == null ? 0 : orderProvider.orders[widget.index].coupon!.type == DiscountType.percentage ? (orderProvider.orders[widget.index].coupon!.discount * 0.01 * orderProvider.orders[widget.index].products.map((e) => (e.price) * ((e.quantity))).reduce(
                                      (value, element) => value + element,
                                    )) : orderProvider.orders[widget.index].coupon!.discount)}',
                              ),
                            ],
                          ),
                        ),
                        ...(orderProvider.orders[widget.index].status
                                .where((element) => element == 7)
                                .isNotEmpty
                            ? []
                            : [
                                const SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  'Payment Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Builder(builder: (context) {
                                  final paymentData = orderProvider
                                      .orders[widget.index].paymentMethod;
                                  return paymentData is CardPaymentMethod
                                      ? Row(
                                          children: [
                                            SvgPicture.network(
                                              paymentData.cardNetwork
                                                          .toLowerCase() ==
                                                      'mastercard'
                                                  ? 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Mastercard_2019_logo.svg'
                                                  : paymentData.cardNetwork
                                                              .toLowerCase() ==
                                                          'visa'
                                                      ? 'https://upload.wikimedia.org/wikipedia/commons/d/d6/Visa_2021.svg'
                                                      : paymentData.cardNetwork
                                                                  .toLowerCase() ==
                                                              'rupay'
                                                          ? 'https://upload.wikimedia.org/wikipedia/commons/d/d1/RuPay.svg'
                                                          : paymentData
                                                                      .cardNetwork
                                                                      .toLowerCase() ==
                                                                  'maestro'
                                                              ? 'https://upload.wikimedia.org/wikipedia/commons/8/80/Maestro_2016.svg'
                                                              : paymentData
                                                                          .cardNetwork
                                                                          .toLowerCase() ==
                                                                      'american express'
                                                                  ? 'https://upload.wikimedia.org/wikipedia/commons/f/fa/American_Express_logo_%282018%29.svg'
                                                                  : 'https://upload.wikimedia.org/wikipedia/commons/f/f3/Credit_card.svg',
                                              height: 36,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(paymentData.name == ""
                                                    ? FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.displayName ??
                                                        "User"
                                                    : paymentData.name),
                                                Text(
                                                    "**** **** **** ${paymentData.last4}"),
                                                Text(
                                                    "${paymentData.cardIssuer} ${paymentData.cardType} Card"),
                                              ],
                                            ),
                                          ],
                                        )
                                      : paymentData is UPIPaymentMethod
                                          ? Row(
                                              children: [
                                                SvgPicture.network(
                                                  paymentData.vpa
                                                          .contains('ybl')
                                                      ? 'https://upload.wikimedia.org/wikipedia/commons/7/71/PhonePe_Logo.svg'
                                                      : paymentData.vpa
                                                              .contains('@ok')
                                                          ? 'https://upload.wikimedia.org/wikipedia/commons/c/c7/Google_Pay_Logo_%282020%29.svg'
                                                          : 'https://upload.wikimedia.org/wikipedia/commons/e/e1/UPI-Logo-vector.svg',
                                                  height: 36,
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(paymentData.name == ""
                                                        ? FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.displayName ??
                                                            "User"
                                                        : paymentData.name),
                                                    Text(paymentData.vpa),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : paymentData is WalletPaymentMethod
                                              ? Row(
                                                  children: [
                                                    SvgPicture.network(
                                                      paymentData.walletType
                                                                  .toLowerCase() ==
                                                              'paytm'
                                                          ? 'https://upload.wikimedia.org/wikipedia/commons/2/24/Paytm_Logo_%28standalone%29.svg'
                                                          : paymentData
                                                                  .walletType
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'amazon')
                                                              ? 'https://upload.wikimedia.org/wikipedia/commons/2/29/Amazon_Pay_logo.svg'
                                                              : 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Apple_Wallet_Icon.svg',
                                                      height: 36,
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(paymentData.name ==
                                                                ""
                                                            ? FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.displayName ??
                                                                "User"
                                                            : paymentData.name),
                                                        Text(paymentData
                                                            .walletType),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : paymentData
                                                      is CashOnDeliveryPaymentMethod
                                                  ? Row(
                                                      children: [
                                                        const Icon(Icons.money),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(paymentData
                                                                        .name ==
                                                                    ""
                                                                ? FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        ?.displayName ??
                                                                    "User"
                                                                : paymentData
                                                                    .name),
                                                            const Text(
                                                                'Cash on Delivery'),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.warning),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        Text(paymentData.name),
                                                      ],
                                                    );
                                }),
                              ]),
                        const SizedBox(
                          height: 28,
                        ),
                        Text(
                          'Deliver to',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Builder(builder: (context) {
                          final shippingAddress = orderProvider
                              .orders[widget.index].shippingAddress;
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
                      ],
                    ),
                  )
                ],
              )),
            ),
          );
        });
      });
    });
  }

  Future<void> cancelOrder(OrderProvider orderProvider) async {
    var basicAuth = base64Encode(
        utf8.encode('${RazorpaySecret.keyId}:${RazorpaySecret.keySecret}'));
    final amount = orderProvider.orders[widget.index].products
            .map((e) => (e.price) * ((e.quantity)))
            .reduce(
              (value, element) => value + element,
            ) -
        (orderProvider.orders[widget.index].coupon == null
            ? 0
            : orderProvider.orders[widget.index].coupon!.type ==
                    DiscountType.percentage
                ? (orderProvider.orders[widget.index].coupon!.discount *
                    0.01 *
                    orderProvider.orders[widget.index].products
                        .map((e) => (e.price) * ((e.quantity)))
                        .reduce(
                          (value, element) => value + element,
                        ))
                : orderProvider.orders[widget.index].coupon!.discount);
    print(amount);
    final paymentDetailsResponse = await post(
        Uri.parse(
          'https://api.razorpay.com/v1/payments/${orderProvider.orders[widget.index].razorpayPaymentId}/refund',
        ),
        headers: {
          'Authorization': 'Basic $basicAuth',
          'content-type': 'application/json'
        },
        body: json.encode({
          "amount": amount * 100,
          "reverse_all": 1,
        }));
    final paymentDetails = json.decode(paymentDetailsResponse.body);
    print(paymentDetails);
    if (paymentDetails['status'] == 'processed') {
      await orderProvider.cancelOrder(orderProvider.orders[widget.index]);
      Navigator.of(context).pop();
    }
  }
}
