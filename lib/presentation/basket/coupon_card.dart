import 'package:bheeshmaorganics/data/entitites/coupon.dart';
import 'package:flutter/material.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final Function applyCoupon;
  const CouponCard(this.coupon, {super.key, required this.applyCoupon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coupon.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
              ),
              Text(coupon.description)
            ],
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              coupon.code,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF487D60),
              ),
              onPressed: () {
                applyCoupon();
              },
              child: const Text('APPLY'),
            ),
          ],
        ),
      ],
    );
  }
}
