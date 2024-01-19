import 'package:bheeshmaorganics/data/entitites/category.dart';
import 'package:bheeshmaorganics/data/entitites/product.dart';
import 'package:bheeshmaorganics/data/utils/discount_type.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final products = [
    const Product(
        id: 0,
        name: 'Pistachio',
        price: {
          '250 G': 200,
          '500 G': 400,
        },
        image:
            'https://i.pinimg.com/originals/94/c9/93/94c99322f92a7ab4030b130c5937239e.jpg',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
        discount: 20,
        discountType: DiscountType.percentage,
        category: Category(id: 0, name: 'Dry Fruits'),
        cover:
            'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRQdjmIHq1Z6qXC5_oAMemSor5QrU6ECekYPbbsLbtCpX3e1d_c'),
    const Product(
        id: 1,
        name: 'Dried Figs',
        price: {
          '250 G': 200,
          '500 G': 400,
          '1 KG': 800,
        },
        image:
            'https://mir-s3-cdn-cf.behance.net/projects/404/83dcc0177167233.Y3JvcCwyODc2LDIyNTAsOTIsMA.jpg',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
        discount: 20,
        discountType: DiscountType.percentage,
        category: Category(id: 0, name: 'Dry Fruits'),
        cover:
            'https://ayoubs.ca/cdn/shop/articles/dried_figs_460x@2x.png?v=1635282439'),
    const Product(
      id: 2,
      name: 'Raisins',
      price: {
        '250 G': 200,
        '500 G': 400,
        '1 KG': 800,
      },
      image:
          'https://i.pinimg.com/originals/4a/88/55/4a8855c5be2d15cbd79b1291d6d980d7.jpg',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
      discount: 20,
      discountType: DiscountType.percentage,
      category: Category(id: 0, name: 'Dry Fruits'),
      cover:
          'https://www.amritahealthfoods.com/cdn/shop/articles/golden-raisins-lifestyle-7-1680954124667.png?v=1680954339',
    ),
    const Product(
      id: 3,
      name: 'Basmati Rice',
      price: {
        '250 G': 200,
        '500 G': 400,
        '1 KG': 800,
      },
      image:
          'https://media.licdn.com/dms/image/D5622AQGmFXE1xknQOw/feedshare-shrink_1280/0/1687603556119?e=1708560000&v=beta&t=Ra5W1O1FxI4mc30gjYSlzPv2zd2bl870R8zbv77zOpo',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
      discount: 0,
      discountType: DiscountType.percentage,
      category: Category(id: 0, name: 'Dry Fruits'),
      cover:
          'https://www.healthifyme.com/blog/wp-content/uploads/2023/01/shutterstock_400172368-1.jpg',
    ),
  ];
}
