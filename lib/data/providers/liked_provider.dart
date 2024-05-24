import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedItemsProvider extends ChangeNotifier {
  List<int> wishlist = [];

  fetchWishlist() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('wishlist')
        .get()
        .then((value) {
      wishlist = value.docs.map((element) {
        final categoryData = element.data();
        return categoryData['product-id'] as int;
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addProductToLikedItems(
      int productId, ScaffoldMessengerState scaffoldMessenger) async {
    wishlist.add(productId);
    final snackBar = BheeshmaSnackbar(
      title: 'Added to Wishlist',
      message:
          'Successfully added this product to your wishlist for you to savour later!',
      contentType: ContentType.success,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('wishlist')
        .doc(productId.toString())
        .set({'product-id': productId});
    scaffoldMessenger.showSnackBar(snackBar);
    notifyListeners();
  }

  Future<void> removeProductFromLikedItems(
      int productId, ScaffoldMessengerState scaffoldMessenger) async {
    wishlist.remove(productId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('wishlist')
        .doc(productId.toString())
        .delete();
    notifyListeners();
  }
}
