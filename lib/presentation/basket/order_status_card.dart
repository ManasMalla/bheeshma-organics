import 'package:bheeshmaorganics/data/utils/custom_ticket_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderStatusCard extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusCard({
    super.key,
    this.status = OrderStatus.success,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ClipPath(
        clipper: CustomTicketShape(),
        child: SvgPicture.asset(
          status == OrderStatus.success
              ? 'assets/images/success-order.svg'
              : status == OrderStatus.failed
                  ? 'assets/images/failure-order.svg'
                  : 'assets/images/pending-order.svg',
          width: 350,
        ),
      ),
    );
  }
}

enum OrderStatus {
  success,
  failed,
  pending,
}
