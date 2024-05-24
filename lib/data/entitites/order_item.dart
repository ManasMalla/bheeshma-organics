class OrderItem {
  final int? productId;
  final String productName;
  final String size;
  final int quantity;
  final double price;

  const OrderItem({
    this.productId,
    required this.productName,
    required this.size,
    required this.quantity,
    required this.price,
  });
}
