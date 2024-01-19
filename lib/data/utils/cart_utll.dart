import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';

doesProductExistInCart(
    List<CartItem> cart, Product product, int quantitySelection) {
  return cart
      .where((e) => e.productId == product.id && (e.size == quantitySelection || quantitySelection == -1))
      .isNotEmpty;
}
