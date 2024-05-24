import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:bheeshmaorganics/data/entitites/order_item.dart';
import 'package:bheeshmaorganics/data/entitites/payment_method.dart';

class Order {
  final int id;
  final List<OrderItem> products;
  final DateTime date;
  final List<int> status;
  final List<Map<String, String>> trackingIds;

  final PaymentMethod paymentMethod;
  final Address shippingAddress;
  final Address billingAddress;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final Coupon? coupon;
  const Order(
      {required this.id,
      required this.products,
      required this.date,
      required this.status,
      required this.trackingIds,
      required this.paymentMethod,
      required this.shippingAddress,
      required this.billingAddress,
      this.coupon,
      this.razorpayOrderId,
      this.razorpayPaymentId});

  Order copyWith({
    int? id,
    List<OrderItem>? products,
    DateTime? date,
    List<int>? status,
    List<Map<String, String>>? trackingIds,
    PaymentMethod? paymentMethod,
    Address? shippingAddress,
    Address? billingAddress,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    Coupon? coupon,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      date: date ?? this.date,
      status: status ?? this.status,
      trackingIds: trackingIds ?? this.trackingIds,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
      coupon: coupon ?? this.coupon,
    );
  }
}
