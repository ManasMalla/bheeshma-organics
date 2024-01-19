import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bheeshmaorganics/presentation/bheeshma_snackbar.dart';
import 'package:flutter/material.dart';

class LikedItemsProvider extends ChangeNotifier {
  List<int> wishlist = [];
  void addProductToLikedItems(
      int productId, ScaffoldMessengerState scaffoldMessenger) {
    wishlist.add(productId);
    final snackBar = BheeshmaSnackbar(
      title: 'Added to Wishlist',
      message:
          'Successfully added this product to your wishlist for you to savour later!',
      contentType: ContentType.success,
    );
    scaffoldMessenger.showSnackBar(snackBar);
    notifyListeners();
  }

  void removeProductFromLikedItems(
      int productId, ScaffoldMessengerState scaffoldMessenger) {
    wishlist.remove(productId);
    notifyListeners();
  }
}
