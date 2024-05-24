import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> addresses = [];
  fetchAddresses() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('addresses')
        .get()
        .then((value) {
      addresses = value.docs.map((element) {
        final categoryData = element.data();
        return Address(
          doorNumber: categoryData['door-number'],
          building: categoryData['building'],
          street: categoryData['street'],
          city: categoryData['city'],
          state: categoryData['state'],
          pincode: categoryData['pincode'],
          landmark: categoryData['landmark'],
          phoneNumber: categoryData['phone-number'],
          name: categoryData['name'],
          id: categoryData['id'],
          type: categoryData['type'],
          distance: categoryData['distance'],
        );
      }).toList();
      notifyListeners();
    });
  }

  Future<void> addAddress(Address address) async {
    addresses.add(address);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('addresses')
        .doc(address.id.toString())
        .set({
      'door-number': address.doorNumber,
      'building': address.building,
      'street': address.street,
      'city': address.city,
      'state': address.state,
      'pincode': address.pincode,
      'landmark': address.landmark,
      'phone-number': address.phoneNumber,
      'name': address.name,
      'id': address.id,
      'type': address.type,
      'distance': address.distance,
    });
    notifyListeners();
  }

  void deleteAddress(Address address) {
    addresses.remove(address);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('addresses')
        .doc(address.id.toString())
        .delete();
    notifyListeners();
  }

  Future<void> updateAddress(Address address) async {
    addresses[addresses.indexWhere((element) => element.id == address.id)] =
        address;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('addresses')
        .doc(address.id.toString())
        .update({
      'door-number': address.doorNumber,
      'building': address.building,
      'street': address.street,
      'city': address.city,
      'state': address.state,
      'pincode': address.pincode,
      'landmark': address.landmark,
      'phone-number': address.phoneNumber,
      'name': address.name,
      'id': address.id,
      'type': address.type,
      'distance': address.distance,
    });
    notifyListeners();
  }
}
