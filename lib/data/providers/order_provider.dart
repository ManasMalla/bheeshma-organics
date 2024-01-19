import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:bheeshmaorganics/data/entitites/order.dart';
import 'package:bheeshmaorganics/data/entitites/order_item.dart';
import 'package:bheeshmaorganics/data/entitites/payment_method.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  var orders = [
    Order(
      id: 1,
      products: const [
        OrderItem(
            productName: 'Basmati Rice', quantity: 2, price: 800, size: '1 Kg'),
        OrderItem(
            productName: 'Raisins', quantity: 4, size: '250 g', price: 160),
        OrderItem(
            productName: 'Pistachio', quantity: 2, size: '250g', price: 160),
      ],
      date: DateTime(2024, 01, 13, 12, 30),
      status: [1, 0, 0],
      coupon: Coupon(
        code: 'MANAS20',
        id: 'developer-2024',
        description: 'Get flat 20% off on purchasing the Bheesma organics food',
        name: 'Developer Deed',
        type: DiscountType.percentage,
        discount: 20,
        minimumOrderAmount: 300,
        maximumDiscountAmount: 300.0,
        validFrom: DateTime(2024, 01, 01),
        validTill: DateTime(2024, 02, 01),
        isActive: true,
      ),
      paymentMethod: const CardPaymentMethod(
          name: 'Manas Malla',
          last4: '6789',
          cardIssuer: 'HDFC',
          cardNetwork: 'Mastercard',
          cardType: 'Debit'),
      shippingAddress: const Address(
        doorNumber: '50-103-4',
        building: 'Uma Sivam Residency',
        street: 'T.P.T Colony',
        city: 'Visakpatnam',
        state: 'Andhra Pradesh',
        pincode: '530013',
        landmark: 'Near Queens NRI Hospital',
        phoneNumber: '9059145216',
        name: 'Manas Malla',
        id: 0,
        type: 'Home',
        distance: 523000,
      ),
      billingAddress: const Address(
        doorNumber: '50-103-4',
        building: 'Uma Sivam Residency',
        street: 'T.P.T Colony',
        city: 'Visakpatnam',
        state: 'Andhra Pradesh',
        pincode: '530013',
        landmark: 'Near Queens NRI Hospital',
        phoneNumber: '9059145216',
        name: 'Manas Malla',
        id: 0,
        type: 'Home',
        distance: 523000,
      ),
    )
  ];
}
