import 'package:bheeshmaorganics/data/entitites/advertisements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdvertisementProvider extends ChangeNotifier {
  List<String> imageAd = [];
  List<Advertisement> advertisement = [
    // Advertisement(
    //   title: 'Amazing Almonds',
    //   subtitle: 'Rich in vitamin A',
    //   description:
    //       'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //   arguments: 3,
    // ),
    // Advertisement(
    //   title: 'Pleasing Pistachio',
    //   subtitle: 'Rich in vitamin E',
    //   description:
    //       'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //   arguments: 0,
    //   cta: "Order Now",
    // ),
    // Advertisement(
    //     title: 'Delicious Dried Figs',
    //     subtitle: 'Rich in vitamin C',
    //     description:
    //         'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //     arguments: 1),
    // Advertisement(
    //     title: 'Ravishing Raisins',
    //     subtitle: 'Rich in vitamin B',
    //     description:
    //         'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //     arguments: 2),
  ];
  // fetchAdvertisements() async {
  //   await FirebaseFirestore.instance
  //       .collection('advertisements')
  //       .get()
  //       .then((value) {
  //     advertisement = value.docs.map((element) {
  //       final categoryData = element.data();
  //       return Advertisement(
  //         id: element.id,
  //         title: categoryData['title'],
  //         subtitle: categoryData['subtitle'],
  //         description: categoryData['description'],
  //         arguments: categoryData['arguments'],
  //         cta: categoryData['cta'] ?? 'Know More',
  //         route: categoryData['route'] ?? '/product',
  //       );
  //     }).toList();
  //     notifyListeners();
  //   });
  // }
  fetchImageAdvertisements() async {
    await FirebaseFirestore.instance
        .collection('image-ads')
        .get()
        .then((value) {
      imageAd = value.docs.map((element) {
        final categoryData = element.data();
        return categoryData['url'] as String;
      }).toList();
      notifyListeners();
    });
  }
}
