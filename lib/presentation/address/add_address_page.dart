import 'dart:math';

import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/data/providers/address_provider.dart';
import 'package:bheeshmaorganics/data/utils/get_themed_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  final Address? address;
  const AddAddressPage({
    super.key,
    this.address,
  });

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  var state;
  var doorNumberController = TextEditingController();
  var buildingController = TextEditingController();
  var streetController = TextEditingController();
  var cityController = TextEditingController();
  var pincodeController = TextEditingController();
  var landmarkController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.address?.name);
    doorNumberController =
        TextEditingController(text: widget.address?.doorNumber);
    buildingController = TextEditingController(text: widget.address?.building);
    streetController = TextEditingController(text: widget.address?.street);
    cityController = TextEditingController(text: widget.address?.city);
    pincodeController =
        TextEditingController(text: widget.address?.pincode.toString());
    landmarkController = TextEditingController(text: widget.address?.landmark);
    phoneNumberController =
        TextEditingController(text: widget.address?.phoneNumber);
    state = widget.address?.state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.yellow,
              height: 300,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 64,
                    child: SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 100,
                      colorFilter: ColorFilter.mode(
                        Colors.amber.shade400.withOpacity(0.5),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 72,
                      color: Colors.amber.shade400,
                    ),
                    bottom: 0,
                    left: 0,
                    right: 0,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 18,
                    child: SvgPicture.asset(
                      "assets/images/delivery-address.svg",
                      height: 300,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.rotate(
                      angle: pi,
                      child: SvgPicture.asset(
                        'assets/icons/logo.svg',
                        height: 100,
                        colorFilter: ColorFilter.mode(
                          Colors.amber.shade400.withOpacity(0.5),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "Add Address",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "Where should we ship your fresh food?",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Door Number',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          controller: doorNumberController,
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Building',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          controller: buildingController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Street',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: streetController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'City',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          controller: cityController,
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      DropdownButton<String>(
                        items: [
                          "Andhra Pradesh",
                          "Arunachal Pradesh",
                          "Assam",
                          "Bihar",
                          "Chhattisgarh",
                          "Goa",
                          "Gujarat",
                          "Haryana",
                          "Himachal Pradesh",
                          "Jharkhand",
                          "Karnataka",
                          "Kerala",
                          "Madhya Pradesh",
                          "Maharashtra",
                          "Manipur",
                          "Meghalaya",
                          "Mizoram",
                          "Nagaland",
                          "Odisha",
                          "Punjab",
                          "Rajasthan",
                          "Sikkim",
                          "Tamil Nadu",
                          "Telangana",
                          "Tripura",
                          "Uttar Pradesh",
                          "Uttarakhand",
                          "West Bengal",
                          "Andaman and\nNicobar Islands",
                          "Daman and Diu",
                          "Jammu and Kashmir",
                          "Ladakh",
                          "Lakshadweep",
                          "NCT of Delhi",
                          "Puducherry",
                          "Chandigarh",
                        ].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        borderRadius: BorderRadius.circular(8),
                        underline: const SizedBox(),
                        // selectedItemBuilder: (context) {
                        //   return [
                        //     Container(
                        //         padding:
                        //             const EdgeInsets.only(left: 16, right: 16),
                        //         decoration: BoxDecoration(
                        //             color: Theme.of(context)
                        //                 .colorScheme
                        //                 .surfaceVariant,
                        //             borderRadius: BorderRadius.circular(8)),
                        //         child: Center(child: Text(state))),
                        //   ];
                        // },
                        hint: const Text('State'),
                        onChanged: (_) {
                          state = _;
                          setState(() {});
                        },
                        value: state,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pincodeController,
                          decoration: InputDecoration(
                            hintText: 'Pincode',
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: landmarkController,
                    decoration: InputDecoration(
                      hintText: 'Landmark',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Consumer<AddressProvider>(
                      builder: (context, addressProvider, _) {
                    return FilledButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            doorNumberController.text.isEmpty ||
                            buildingController.text.isEmpty ||
                            streetController.text.isEmpty ||
                            cityController.text.isEmpty ||
                            pincodeController.text.isEmpty ||
                            phoneNumberController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please fill all the fields'),
                          ));
                          return;
                        }
                        final newAddress = Address(
                          name: nameController.text,
                          doorNumber: doorNumberController.text,
                          building: buildingController.text,
                          street: streetController.text,
                          city: cityController.text,
                          state: state,
                          pincode: pincodeController.text,
                          landmark: landmarkController.text,
                          phoneNumber: phoneNumberController.text,
                          type: 'Home',
                          id: widget.address?.id ??
                              addressProvider.addresses.length,
                          distance: 0,
                        );
                        if (widget.address == null) {
                          addressProvider.addAddress(
                            newAddress,
                          );
                        } else {
                          addressProvider.updateAddress(newAddress);
                        }
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor: getThemedColor(
                              context, Colors.black, Colors.white),
                          foregroundColor: getThemedColor(
                              context, Colors.white, Colors.black)),
                      child: Text(widget.address == null
                          ? "Add Address"
                          : "Update Address"),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
