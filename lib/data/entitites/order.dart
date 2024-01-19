import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:bheeshmaorganics/data/entitites/order_item.dart';
import 'package:bheeshmaorganics/data/entitites/payment_method.dart';

class Order {
  final int id;
  final List<OrderItem> products;
  final DateTime date;
  final List<int> status;
  final PaymentMethod paymentMethod;
  final Address shippingAddress;
  final Address billingAddress;
  final Coupon? coupon;
  const Order({
    required this.id,
    required this.products,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.billingAddress,
    this.coupon,
  });
}
