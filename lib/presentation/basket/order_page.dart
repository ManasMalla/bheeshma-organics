import 'package:bheeshmaorganics/presentation/basket/order_status_card.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    //ModalRoute.of(context)?.settings.arguments as int
    final integerOrderStatus = 0;
    final orderStatus = OrderStatus.values[integerOrderStatus];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF4FFF9),
          leading: IconButton(
            icon: const Icon(
              FeatherIcons.arrowLeft,
              color: Color(0xFF006738),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xFFF4FFF9),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300,
                color: orderStatus == OrderStatus.success
                    ? const Color(0xFFABDFC2)
                    : orderStatus == OrderStatus.failed
                        ? const Color(0xFFDB7D7C)
                        : const Color(0xFF89750D),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed('/order-details');
              },
              child: OrderStatusCard(
                status: orderStatus,
              ),
            ),
          ],
        ));
  }
}
