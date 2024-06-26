import 'dart:convert';
import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:bheeshmaorganics/data/entitites/order_item.dart';
import 'package:bheeshmaorganics/data/entitites/payment_method.dart';
import 'package:bheeshmaorganics/data/providers/address_provider.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/coupon_provider.dart';
import 'package:bheeshmaorganics/data/providers/order_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/razorpay_integration.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:bheeshmaorganics/data/utils/razorpay_options.dart';
import 'package:bheeshmaorganics/data/utils/secrets.dart';
import 'package:bheeshmaorganics/presentation/address/add_address_page.dart';
import 'package:bheeshmaorganics/presentation/address/address_card.dart';
import 'package:bheeshmaorganics/presentation/basket/basket_item.dart';
import 'package:bheeshmaorganics/presentation/basket/coupon_card.dart';
import 'package:bheeshmaorganics/presentation/basket/order_status_card.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Coupon? coupon;
  Address? address;
  var paymentInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      return Consumer<ProductProvider>(builder: (context, productProvider, _) {
        final products = productProvider.products;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF699E81),
            foregroundColor: Colors.white,
          ),
          backgroundColor: const Color(0xFF699E81),
          body: Consumer<CartProvider>(builder: (context, cartProvider, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0).copyWith(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Review\nyour order",
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        foregroundColor: coupon == null
                            ? Colors.white
                            : const Color(0xFF487D60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                          40,
                        )),
                        backgroundColor: coupon == null ? null : Colors.white,
                      ),
                      onPressed: () {
                        if (coupon != null) {
                          setState(() {
                            coupon = null;
                          });
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              final couponEditingController =
                                  TextEditingController();
                              return Dialog(
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  child: Consumer<CouponProvider>(
                                      builder: (context, couponProvider, _) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Enter coupon code',
                                                ),
                                                controller:
                                                    couponEditingController,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF487D60),
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                final couponCode =
                                                    couponEditingController
                                                        .text;
                                                if (couponCode.isNotEmpty) {
                                                  final searchQuery =
                                                      couponProvider
                                                          .coupons
                                                          .where((element) =>
                                                              element.code ==
                                                              couponCode);
                                                  if (searchQuery.isNotEmpty) {
                                                    if (searchQuery.first
                                                            .minimumOrderAmount >
                                                        cartProvider
                                                            .calculateTotalPrice(
                                                                products:
                                                                    products)) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        BheeshmaSnackbar(
                                                            title: 'Oops.',
                                                            message:
                                                                'Unable to apply coupon code. Minimum order amount is ₹${searchQuery.first.minimumOrderAmount}',
                                                            contentType:
                                                                ContentType
                                                                    .failure),
                                                      );
                                                      return;
                                                    }
                                                    setState(() {
                                                      coupon =
                                                          searchQuery.first;
                                                    });
                                                    couponEditingController
                                                        .clear();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      BheeshmaSnackbar(
                                                          title: 'Oops ',
                                                          message:
                                                              'Coupon code not valid',
                                                          contentType:
                                                              ContentType
                                                                  .failure),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text('REDEEM'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Row(
                                          children: [
                                            Expanded(child: Divider()),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'or',
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(child: Divider()),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        ListView.separated(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: couponProvider.coupons
                                                .where((element) =>
                                                    element.isVisible)
                                                .length,
                                            separatorBuilder: (_, __) =>
                                                const Divider(),
                                            itemBuilder: (context, index) {
                                              final couponInfo = couponProvider
                                                  .coupons
                                                  .where((element) =>
                                                      element.isVisible)
                                                  .toList()[index];
                                              return CouponCard(couponInfo,
                                                  applyCoupon: () {
                                                setState(() {
                                                  coupon = couponInfo;
                                                });
                                                Navigator.of(context).pop();
                                              });
                                            }),
                                      ],
                                    );
                                  }),
                                ),
                              );
                            });
                      },
                      child: Row(
                        children: [
                          Text(
                            coupon == null
                                ? 'Apply Coupon'
                                : 'Applied Coupon: ${coupon?.code}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: coupon == null
                                      ? Colors.white
                                      : const Color(0xFF487D60),
                                ),
                          ),
                          const Spacer(),
                          Icon(
                            coupon == null
                                ? FeatherIcons.arrowRight
                                : FeatherIcons.xCircle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7BB194),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => BasketItem(
                              products
                                  .where((element) =>
                                      cartProvider.cart[index].productId ==
                                      element.id)
                                  .first,
                              quantityChoice: cartProvider.cart[index].size,
                              quantity: cartProvider.cart[index].quantity,
                              modifyItemCount: (delta) {},
                              isReview: true,
                            ),
                            separatorBuilder: (context, _) => const SizedBox(
                              height: 12,
                            ),
                            itemCount: cartProvider.cart.length,
                            shrinkWrap: true,
                            primary: false,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(
                            color: Colors.white,
                          ),
                          coupon == null
                              ? const SizedBox()
                              : const SizedBox(
                                  height: 12,
                                ),
                          coupon == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Text(
                                      'DISCOUNT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "- ₹${min(coupon!.maximumDiscountAmount, coupon!.type == DiscountType.percentage ? cartProvider.calculateTotalPrice(products: products) * (coupon!.discount) / 100 : coupon!.discount)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 12,
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
                                      fontSize: 18,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                "₹ ${cartProvider.calculateTotalPrice(products: products) - (coupon == null ? 0 : (min(coupon!.maximumDiscountAmount, coupon!.type == DiscountType.percentage ? cartProvider.calculateTotalPrice(products: products) * (coupon!.discount) / 100 : coupon!.discount))).ceil()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'please choose where we should deliver your nutritious order',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Consumer<AddressProvider>(
                        builder: (context, addressProvider, _) {
                      return SizedBox(
                        height: addressProvider.addresses.isEmpty ? 48 : 180,
                        child: addressProvider.addresses.isEmpty
                            ? Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF699E81),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AddAddressPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'ADD ADDRESS',
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
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, _) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (address ==
                                            addressProvider.addresses[_]) {
                                          address = null;
                                          return;
                                        }
                                        address = addressProvider.addresses[_];
                                      });
                                    },
                                    child: AddressCard(
                                      addressProvider.addresses[_],
                                      selected: address ==
                                          addressProvider.addresses[_],
                                      onDelete: () {},
                                    ),
                                  );
                                },
                                separatorBuilder: (context, _) =>
                                    const Divider(),
                                itemCount: addressProvider.addresses.length),
                      );
                    }),
                    const SizedBox(
                      height: 24,
                    ),
                    // Text(
                    //   'Estimated Delivery',
                    //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    // ),
                    // AnimatedCrossFade(
                    //   crossFadeState: address != null
                    //       ? CrossFadeState.showFirst
                    //       : CrossFadeState.showSecond,
                    //   duration: const Duration(milliseconds: 300),
                    //   firstChild: Text(
                    //     "${DateFormat('dd MMM yyyy h:00 a').format(
                    //           DateTime.now().add(
                    //             Duration(
                    //               days: (address?.distance ?? 0) ~/ 200000,
                    //             ),
                    //           ),
                    //         )} - ${DateFormat('h:00 a').format(
                    //           DateTime.now().add(
                    //             Duration(
                    //               days: (address?.distance ?? 0) ~/ 200000,
                    //               hours: 3,
                    //             ),
                    //           ),
                    //         )}",
                    //     style:
                    //         Theme.of(context).textTheme.titleMedium?.copyWith(
                    //               color: Colors.white.withOpacity(0.6),
                    //             ),
                    //   ),
                    //   secondChild: const SizedBox(),
                    // ),
                    // const SizedBox(
                    //   height: 24,
                    // ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF699E81),
                        ),
                        onPressed: paymentInProgress
                            ? null
                            : () {
                                if (address == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    BheeshmaSnackbar(
                                      title: 'Oops.',
                                      message:
                                          'Please select a delivery address',
                                      contentType: ContentType.failure,
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  paymentInProgress = true;
                                });
                                RazorPayIntegration razorPayIntegration =
                                    RazorPayIntegration(
                                        onSuccess: (result) async {
                                  var basicAuth = base64Encode(utf8.encode(
                                      '${RazorpaySecret.keyId}:${RazorpaySecret.keySecret}'));
                                  final paymentDetailsResponse = await get(
                                    Uri.parse(
                                      'https://api.razorpay.com/v1/payments/${result.paymentId}/?expand[]=card',
                                    ),
                                    headers: {
                                      'Authorization': 'Basic $basicAuth'
                                    },
                                  );
                                  final paymentDetails =
                                      json.decode(paymentDetailsResponse.body);
                                  print(paymentDetails);
                                  orderProvider.addOrder(
                                    cartProvider.cart.map((e) {
                                      final product = products
                                          .where((element) =>
                                              element.id == e.productId)
                                          .first;
                                      return OrderItem(
                                        productId: e.productId,
                                        productName: product.name,
                                        size: product.price[e.size].quantity,
                                        quantity: e.quantity,
                                        price: product
                                            .discountedPrices[e.size].price,
                                      );
                                    }).toList(),
                                    coupon,
                                    paymentDetails['method'] == 'card'
                                        ? CardPaymentMethod(
                                            name: paymentDetails['card']
                                                ['name'],
                                            last4: paymentDetails['card']
                                                ['last4'],
                                            cardIssuer: paymentDetails['card']
                                                ['issuer'],
                                            cardNetwork: paymentDetails['card']
                                                ['network'],
                                            cardType: paymentDetails['card']
                                                ['type'])
                                        : paymentDetails['method'] == 'upi'
                                            ? UPIPaymentMethod(
                                                name: FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.displayName ??
                                                    '',
                                                vpa: paymentDetails['vpa'])
                                            : paymentDetails['method'] ==
                                                    'netbanking'
                                                ? WalletPaymentMethod(
                                                    name: FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.displayName ??
                                                        '',
                                                    walletType:
                                                        paymentDetails['bank'])
                                                : paymentDetails['method'] ==
                                                        'emi'
                                                    ? WalletPaymentMethod(
                                                        name: FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.displayName ??
                                                            '',
                                                        walletType:
                                                            paymentDetails['emi']
                                                                ['issuer'])
                                                    : paymentDetails['method'] ==
                                                            'wallet'
                                                        ? WalletPaymentMethod(name: FirebaseAuth.instance.currentUser?.displayName ?? '', walletType: paymentDetails['wallet'])
                                                        : const CashOnDeliveryPaymentMethod(),
                                    address!,
                                    cartProvider,
                                    productProvider,
                                    result.orderId ?? '',
                                    onOrderPlaced: (id) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        '/order-status',
                                        (route) =>
                                            route.settings.name == '/home',
                                        arguments: {
                                          'status': OrderStatus.success,
                                          'id': id,
                                        },
                                      );
                                    },
                                    razorPayPaymentId: result.paymentId,
                                  );
                                  orderProvider
                                      .checkIfInPendingPayments(result.orderId);
                                }, onFailure: (failure, razorPayorderId) {
                                  orderProvider.addOrder(
                                      cartProvider.cart.map((e) {
                                        final product = products
                                            .where((element) =>
                                                element.id == e.productId)
                                            .first;
                                        return OrderItem(
                                          productId: e.productId,
                                          productName: product.name,
                                          size: product.price[e.size].quantity,
                                          quantity: e.quantity,
                                          price: product
                                              .discountedPrices[e.size].price,
                                        );
                                      }).toList(),
                                      coupon,
                                      PaymentMethod(
                                        name: 'Failure',
                                      ),
                                      address!,
                                      cartProvider,
                                      productProvider,
                                      razorPayorderId ?? '',
                                      onOrderPlaced: (id) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      '/order-status',
                                      (route) => route.settings.name == '/home',
                                      arguments: {
                                        'status': OrderStatus.failed,
                                        'id': id,
                                      },
                                    );
                                  }, isFailure: true);
                                  orderProvider.checkIfInPendingPayments(
                                      razorPayorderId);
                                });
                                razorPayIntegration.initializeRazorpay();
                                razorPayIntegration.openRazorpay(
                                  FirebaseAuth.instance.currentUser?.uid ?? "",
                                  amount: (cartProvider.calculateTotalPrice(
                                                  products: products) -
                                              (coupon == null
                                                  ? 0
                                                  : (min(
                                                      coupon!
                                                          .maximumDiscountAmount,
                                                      coupon!.type ==
                                                              DiscountType
                                                                  .percentage
                                                          ? cartProvider
                                                                  .calculateTotalPrice(
                                                                      products:
                                                                          products) *
                                                              (coupon!
                                                                  .discount) /
                                                              100
                                                          : coupon!.discount))))
                                          .ceil() *
                                      100,
                                  currency: 'INR',
                                  businessName: 'Bheeshma Naturals',
                                  receipt: 'receipt#001',
                                  prefill: Prefill(
                                    userContact: FirebaseAuth
                                        .instance.currentUser?.phoneNumber,
                                  ),
                                  description: 'Order from Bheeshma Naturals',
                                );
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              paymentInProgress ? 'Payment In Progress' : 'Pay',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
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
              ),
            );
          }),
        );
      });
    });
  }
}
