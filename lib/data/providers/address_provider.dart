import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> addresses = [
    Address(
      doorNumber: '50-103-4',
      building: 'Uma Sivam Residency',
      street: 'T.P.T Colony',
      city: 'Visakpatnam',
      state: 'Andhra Pradesh',
      pincode: '530013',
      landmark: 'Near Queens NRI Hospital',
      phoneNumber: '9059145216',
      name: 'Manas Malla',
      id: 0,
      type: 'Home',
      distance: 523000,
    ),
  ];
  void addAddress(Address address) {
    addresses.add(address);
    notifyListeners();
  }

  void deleteAddress(Address address) {
    addresses.remove(address);
    notifyListeners();
  }

  void updateAddress(Address address) {
    addresses[addresses.indexWhere((element) => element.id == address.id)] =
        address;
    notifyListeners();
  }
}
