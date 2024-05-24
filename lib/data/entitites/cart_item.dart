class CartItem {
  final int productId;
  final int quantity;
  final int size;
  final String id;
  const CartItem({
    required this.productId,
    required this.quantity,
    required this.size,
    this.id = '',
  });
  CartItem copyWith({
    productId,
    quantity,
    size,
    id,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      id: id ?? this.id,
    );
  }
}
