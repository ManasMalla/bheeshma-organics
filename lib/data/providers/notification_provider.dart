import 'package:bheeshmaorganics/data/entitites/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<BheeshmaNotification> notification = [
    // const BheeshmaNotification(
    //     title: 'Happy Sankranthi',
    //     body:
    //         'This sankranthi have a feast with your family with Bheeshma Naturals fresh organic rice! We have added a new product to our store. Check it out now!',
    //     image:
    //         'https://t4.ftcdn.net/jpg/04/03/98/77/360_F_403987784_eMB97Bj3m7peE5Hh2uKI2NFXj5Gwi9zC.jpg',
    //     type: 'discover',
    //     id: 'sankranthi',
    //     cta: 'Shop now',
    //     payload: '',
    //     route: '/home',
    //     updatedAt: '2024-01-12'),
  ];
  fetchNotification() async {
    await fetchGeneralNotifications().then((_) async {
      await fetchUserNotifications();
    });
  }

  fetchGeneralNotifications() async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .get()
        .then((value) {
      notification = value.docs.map((element) {
        final categoryData = element.data();
        print(categoryData);
        return BheeshmaNotification(
          title: categoryData['title'],
          body: categoryData['body'],
          image: categoryData['image'],
          type: categoryData['type'],
          id: categoryData['id'],
          updatedAt: categoryData['updatedAt'],
          cta: categoryData['cta'] ?? 'Explore Now',
          payload: categoryData['payload'] ?? '',
          route: categoryData['route'] ?? '',
        );
      }).toList();
      print(notification);
      notifyListeners();
    });
  }

  fetchUserNotifications() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notifications')
        .get()
        .then((value) {
      final userNotifications = value.docs.map((element) {
        final categoryData = element.data();
        return BheeshmaNotification(
          title: categoryData['title'],
          body: categoryData['body'],
          image: categoryData['image'],
          type: categoryData['type'],
          id: categoryData['id'],
          updatedAt: categoryData['updatedAt'].toDate(),
          cta: categoryData['cta'] ?? 'Explore Now',
          payload: categoryData['payload'] ?? '',
          route: categoryData['route'] ?? '',
        );
      }).toList();
      notification.addAll(userNotifications);
      notifyListeners();
    });
  }
}
