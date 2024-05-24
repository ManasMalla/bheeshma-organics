import 'dart:convert';

import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:bheeshmaorganics/data/entitites/order.dart' as Order;
import 'package:bheeshmaorganics/data/entitites/order_item.dart';
import 'package:bheeshmaorganics/data/entitites/payment_method.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/providers/cart_provider.dart';
import 'package:bheeshmaorganics/data/providers/product_provider.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:bheeshmaorganics/data/utils/secrets.dart';
import 'package:bheeshmaorganics/presentation/basket/order_status_card.dart';
import 'package:bheeshmaorganics/presentation/product/product_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class OrderProvider extends ChangeNotifier {
  List<Order.Order> orders = [];

  fetchOrders(List<Address> addresses) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('orders')
          .get()
          .then((value) {
        orders = value.docs.map((element) {
          final categoryData = element.data();

          final products = (categoryData['products'] as List<dynamic>).map((e) {
            final orderItem = OrderItem(
              productName: e['productName'],
              size: e['size'],
              quantity: e['quantity'],
              price: double.parse(
                e['price'].toString(),
              ),
            );
            return orderItem;
          }).toList();
          final paymentMethodData = categoryData['payment-method'];
          final paymentMethod = categoryData['payment-method-type'] == 'card'
              ? CardPaymentMethod(
                  name: paymentMethodData['name'],
                  last4: paymentMethodData['last4'],
                  cardType: paymentMethodData['card-type'],
                  cardIssuer: paymentMethodData['card-issuer'],
                  cardNetwork: paymentMethodData['card-network'])
              : categoryData['payment-method-type'] == 'upi'
                  ? UPIPaymentMethod(
                      name: paymentMethodData['name'],
                      vpa: paymentMethodData['vpa'])
                  : categoryData['payment-method-type'] == 'wallet'
                      ? WalletPaymentMethod(
                          name: paymentMethodData['name'],
                          walletType: paymentMethodData['wallet-type'])
                      : const CashOnDeliveryPaymentMethod();
          final deliveryStatus =
              (categoryData['delivery-status'] as List<dynamic>?)?.map((e) {
                    return {
                      'partner': e['partner']?.toString() ?? "",
                      'text': e['text']?.toString() ?? "",
                      'date': e['date'] != null
                          ? (DateTime.tryParse(e['date'])?.toString() ??
                              DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(e['date']))
                                  .toString())
                          : DateTime.now().toString()
                    };
                  }).toList() ??
                  products.map<Map<String, String>>((e) => {}).toList();
          return Order.Order(
            id: categoryData['id'],
            products: products,
            date: DateTime.fromMillisecondsSinceEpoch(
                categoryData['date'] * 1000),
            status: (categoryData['status'] as List<dynamic>)
                .map((e) => int.parse(e.toString()))
                .toList(),
            trackingIds: deliveryStatus,
            coupon: categoryData['coupon'] == null
                ? null
                : Coupon(
                    code: categoryData['coupon']['code'],
                    id: categoryData['coupon']['id'],
                    description: categoryData['coupon']['description'],
                    name: categoryData['coupon']['name'],
                    type: categoryData['coupon']['type'] == 0
                        ? DiscountType.percentage
                        : DiscountType.fixed,
                    discount: categoryData['coupon']['discount'],
                    minimumOrderAmount: categoryData['coupon']['min-order'],
                    maximumDiscountAmount: categoryData['coupon']
                        ['max-discount'],
                    validFrom: DateTime.fromMillisecondsSinceEpoch(
                        categoryData['coupon']['valid-from'] * 1000),
                    validTill: DateTime.fromMillisecondsSinceEpoch(
                        categoryData['coupon']['valid-till'] * 1000),
                    isActive: categoryData['coupon']['is-active'],
                  ),
            paymentMethod: paymentMethod,
            shippingAddress: addresses
                .where((element) => element.id == categoryData['address'])
                .first,
            billingAddress: addresses
                .where((element) => element.id == categoryData['address'])
                .first,
            razorpayOrderId: categoryData['razorpay-order-id'],
            razorpayPaymentId: categoryData['razorpay-payment-id'],
          );
        }).toList();
        orders.sort((a, b) => a.id.compareTo(b.id));
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(
    List<OrderItem> items,
    Coupon? coupon,
    PaymentMethod paymentMethod,
    Address address,
    CartProvider cartProvider,
    ProductProvider productProvider,
    String razorpayOrderId, {
    required Function(int) onOrderPlaced,
    bool isFailure = false,
    String? razorPayPaymentId,
  }) async {
    items.forEach((orderItem) async {
      Product product = productProvider.products[orderItem.productId ?? 0];
      var newPrices = product.price;
      var updatedPriceIndex =
          newPrices.indexWhere((element) => element.quantity == orderItem.size);
      newPrices[updatedPriceIndex] = newPrices[updatedPriceIndex].copyWith(
        stock: newPrices[updatedPriceIndex].stock - orderItem.quantity,
      );
      productProvider.products[orderItem.productId ?? 0] =
          product.copyWith(price: newPrices);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.docId)
          .update({
        'price': newPrices
            .map((e) =>
                {'quantity': e.quantity, 'price': e.price, 'stock': e.stock})
            .toList()
      });
      productProvider.notifyListeners();
    });
    if (!isFailure) {
      cartProvider.clearCart();
    }
    final id = orders.length;
    orders.add(
      Order.Order(
        id: id,
        products: items,
        date: DateTime.now(),
        status: items.map((e) => isFailure ? 7 : 0).toList(),
        trackingIds: items.map((e) => <String, String>{}).toList(),
        coupon: coupon,
        paymentMethod: paymentMethod,
        shippingAddress: address,
        billingAddress: address,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorPayPaymentId,
      ),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('orders')
        .doc(id.toString())
        .set({
      'id': id,
      'products': items.map((e) {
        return {
          'productName': e.productName,
          'size': e.size,
          'quantity': e.quantity,
          'price': e.price,
        };
      }).toList(),
      'date': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'status': items.map((e) => isFailure ? 7 : 0).toList(),
      'razorpay-order-id': razorpayOrderId,
      'razorpay-payment-id': razorPayPaymentId,
      'coupon': coupon != null
          ? {
              'code': coupon.code,
              'id': coupon.id,
              'description': coupon.description,
              'name': coupon.name,
              'type': coupon.type == DiscountType.percentage ? 0 : 1,
              'discount': coupon.discount,
              'min-order': coupon.minimumOrderAmount,
              'max-discount': coupon.maximumDiscountAmount,
              'valid-from': coupon.validFrom.millisecondsSinceEpoch ~/ 1000,
              'valid-till': coupon.validTill.millisecondsSinceEpoch ~/ 1000,
              'is-active': coupon.isActive,
            }
          : null,
      'payment-method-type': paymentMethod is CardPaymentMethod
          ? 'card'
          : paymentMethod is UPIPaymentMethod
              ? 'upi'
              : paymentMethod is WalletPaymentMethod
                  ? 'wallet'
                  : 'cash-on-delivery',
      'payment-method': paymentMethod is CardPaymentMethod
          ? {
              'name': paymentMethod.name,
              'last4': paymentMethod.last4,
              'card-type': paymentMethod.cardType,
              'card-issuer': paymentMethod.cardIssuer,
              'card-network': paymentMethod.cardNetwork,
            }
          : paymentMethod is UPIPaymentMethod
              ? {
                  'name': paymentMethod.name,
                  'vpa': paymentMethod.vpa,
                }
              : paymentMethod is WalletPaymentMethod
                  ? {
                      'name': paymentMethod.name,
                      'wallet-type': paymentMethod.walletType,
                    }
                  : null,
      'address': address.id,
    });
    notifyListeners();
    onOrderPlaced(id);
  }

  Future<void> cancelOrder(Order.Order order) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('orders')
        .doc(order.id.toString())
        .update({
      'status': order.status.map((e) => 7).toList(),
    });
    final newOrder =
        order.copyWith(status: order.status.map((e) => 7).toList());
    orders[order.id] = newOrder;
    notifyListeners();
  }

  checkIfPaymentsPending(CartProvider cartProvider, List<Product> products,
      BuildContext context, ProductProvider productProvider, Address? address) {
    if (address != null) {
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("pending-payments")
        .get()
        .then((pendingPayments) {
      if (pendingPayments.docs.isNotEmpty) {
        pendingPayments.docs.forEach((element) async {
          var basicAuth = base64Encode(utf8
              .encode('${RazorpaySecret.keyId}:${RazorpaySecret.keySecret}'));
          final paymentDetailsResponse = await get(
            Uri.parse(
              'https://api.razorpay.com/v1/orders/${element.id}/payments',
            ),
            headers: {'Authorization': 'Basic $basicAuth'},
          );
          final paymentDetails = json.decode(paymentDetailsResponse.body);
          print(paymentDetails);
          if (paymentDetails["items"][0]["status"] == "failed") {
            checkIfInPendingPayments(element.id);
            return;
          } else if (paymentDetails["items"][0]["status"] == "captured") {
            addOrder(
              cartProvider.cart.map((e) {
                final product = products
                    .where((element) => element.id == e.productId)
                    .first;
                return OrderItem(
                  productId: e.productId,
                  productName: product.name,
                  size: product.price[e.size].quantity,
                  quantity: e.quantity,
                  price: product.discountedPrices[e.size].price,
                );
              }).toList(),
              null,
              paymentDetails['method'] == 'card'
                  ? CardPaymentMethod(
                      name: paymentDetails['card']['name'],
                      last4: paymentDetails['card']['last4'],
                      cardIssuer: paymentDetails['card']['issuer'],
                      cardNetwork: paymentDetails['card']['network'],
                      cardType: paymentDetails['card']['type'])
                  : paymentDetails['method'] == 'upi'
                      ? UPIPaymentMethod(
                          name:
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  '',
                          vpa: paymentDetails['vpa'])
                      : paymentDetails['method'] == 'netbanking'
                          ? WalletPaymentMethod(
                              name: FirebaseAuth
                                      .instance.currentUser?.displayName ??
                                  '',
                              walletType: paymentDetails['bank'])
                          : paymentDetails['method'] == 'emi'
                              ? WalletPaymentMethod(
                                  name: FirebaseAuth
                                          .instance.currentUser?.displayName ??
                                      '',
                                  walletType: paymentDetails['emi']['issuer'])
                              : paymentDetails['method'] == 'wallet'
                                  ? WalletPaymentMethod(
                                      name: FirebaseAuth.instance.currentUser
                                              ?.displayName ??
                                          '',
                                      walletType: paymentDetails['wallet'])
                                  : const CashOnDeliveryPaymentMethod(),
              address!,
              cartProvider,
              productProvider,
              element.id,
              onOrderPlaced: (id) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/order-status',
                  (route) => route.settings.name == '/home',
                  arguments: {
                    'status': OrderStatus.success,
                    'id': id,
                  },
                );
              },
              razorPayPaymentId: paymentDetails["items"][0]["id"],
            );
            checkIfInPendingPayments(element.id);
          }
        });
      }
    });
  }

  void checkIfInPendingPayments(String? razorPayorderId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("pending-payments")
        .get()
        .then((pendingPayments) {
      if (pendingPayments.docs
          .where((element) =>
              element.reference.path.contains(razorPayorderId ?? "not-found"))
          .isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("pending-payments")
            .doc(razorPayorderId)
            .delete();
      }
    });
  }
}
