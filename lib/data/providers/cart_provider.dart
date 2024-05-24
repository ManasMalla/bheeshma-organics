import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/data/entitites/cart_item.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                    .discountedPrices[element.size].price *
                element.quantity));
  }

  fetchCart() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('cart')
        .get()
        .then((value) {
      cart = value.docs.map((element) {
        final categoryData = element.data();
        return CartItem(
          productId: categoryData['id'],
          quantity: categoryData['quantity'],
          size: categoryData['size'],
          id: element.id,
        );
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addProductToCart(
      CartItem cartItem, ScaffoldMessengerState scaffoldMessenger) async {
    final reference = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('cart')
        .add({
      'id': cartItem.productId,
      'quantity': cartItem.quantity,
      'size': cartItem.size,
    });
    cart.add(cartItem.copyWith(id: reference.id));
    final snackBar = BheeshmaSnackbar(
      title: 'Added to Cart',
      message:
          'Successfully added this product to your cart for you to savour now!',
      contentType: ContentType.success,
    );
    scaffoldMessenger.showSnackBar(snackBar);
    notifyListeners();
  }

  Future<void> modifyProduct(int index, int delta) async {
    final updatedQuantity = cart[index].quantity + delta;
    if (updatedQuantity == 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('cart')
          .doc(cart[index].id)
          .delete();
      cart.removeAt(index);
      notifyListeners();
      return;
    }
    cart[index] = cart[index].copyWith(quantity: updatedQuantity);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('cart')
        .doc(cart[index].id)
        .update({
      'id': cart[index].productId,
      'quantity': cart[index].quantity,
      'size': cart[index].size,
    });
    notifyListeners();
  }

  Future<void> clearCart() async {
    cart = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('cart')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference.delete();
      });
    });
    notifyListeners();
  }
}
