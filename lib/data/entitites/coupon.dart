import 'package:bheeshmaorganics/data/utils/discount_type.dart';

class Coupon {
  final String code;
  final String id;
  final String description;
  final String name;
  final DiscountType type;
  final int discount;
  final int minimumOrderAmount;
  final double maximumDiscountAmount;
  final DateTime validFrom;
  final DateTime validTill;
  final bool isActive;
  final bool isVisible;

  const Coupon({
    required this.code,
    required this.id,
    required this.description,
    required this.name,
    required this.type,
    required this.discount,
    required this.minimumOrderAmount,
    required this.maximumDiscountAmount,
    required this.validFrom,
    required this.validTill,
    required this.isActive,
    this.isVisible = false,
  });
}
