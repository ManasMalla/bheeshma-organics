import 'package:bheeshmaorganics/data/providers/address_provider.dart';
import 'package:bheeshmaorganics/presentation/address/add_address_page.dart';
import 'package:bheeshmaorganics/presentation/address/address_card.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(builder: (context, addressProvider, _) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: addressProvider.addresses.isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: SvgPicture.asset(
                      "assets/images/hungry.svg",
                      colorFilter: const ColorFilter.mode(
                          Color(0x60074014), BlendMode.srcIn),
                      width: 170,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "No Addresses",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "You don't have any addresses in your account to deliver your fresh food.",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF699E81),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddAddressPage()));
                      },
                      child: Text(
                        'ADD ADDRESS',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF699E81),
                                ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      FeatherIcons.arrowLeft,
                    ),
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Addresses",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, _) {
                          return AddressCard(
                            addressProvider.addresses[_],
                            canEdit: true,
                            onDelete: () {
                              addressProvider
                                  .deleteAddress(addressProvider.addresses[_]);
                            },
                          );
                        },
                        separatorBuilder: (context, _) => const Divider(),
                        itemCount: addressProvider.addresses.length),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF699E81),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddAddressPage()));
                      },
                      child: Text(
                        'ADD ADDRESS',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF699E81),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
