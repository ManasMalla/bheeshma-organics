import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> cart = [];

  double calculateTotalPrice({required List<Product> products}) {
    return cart.fold(
        0,
        (previousValue, element) =>
            previousValue +
            (products
                    .where((product) => product.id == element.productId)
                    .first
                    .discountedPrices
                    .values
                    .toList()[element.size] *
                element.quantity));
  }

  void addProductToCart(
      CartItem cartItem, ScaffoldMessengerState scaffoldMessenger) {
    cart.add(cartItem);
    final snackBar = BheeshmaSnackbar(
      title: 'Added to Cart',
      message:
          'Successfully added this product to your cart for you to savour now!',
      contentType: ContentType.success,
    );
    scaffoldMessenger.showSnackBar(snackBar);
    notifyListeners();
  }

  void modifyProduct(int index, int delta) {
    final updatedQuantity = cart[index].quantity + delta;
    if (updatedQuantity == 0) {
      cart.removeAt(index);
      notifyListeners();
      return;
    }
    cart[index] = cart[index].copyWith(quantity: updatedQuantity);
    notifyListeners();
  }
}
