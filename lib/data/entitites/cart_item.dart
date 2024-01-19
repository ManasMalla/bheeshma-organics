class CartItem {
  final int productId;
  final int quantity;
  final int size;
  const CartItem({
    required this.productId,
    required this.quantity,
    required this.size,
  });
  CartItem copyWith({
    productId,
    quantity,
    size,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}
