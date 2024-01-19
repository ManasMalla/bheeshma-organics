import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:flutter/material.dart';

class CouponProvider extends ChangeNotifier {
  final coupons = [
    Coupon(
        code: 'PITA100',
        id: 'pitamaha-2024',
        description:
            'Get flat 100₹ off on purchasing the Bheesma organics food',
        name: 'Bheeshma Powerup',
        type: DiscountType.fixed,
        discount: 100,
        minimumOrderAmount: 500,
        maximumDiscountAmount: 100.0,
        validFrom: DateTime(2024, 01, 01),
        validTill: DateTime(2024, 02, 01),
        isActive: true,
        isVisible: true),
    Coupon(
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
  ];
}
