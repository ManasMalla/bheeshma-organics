import 'package:bheeshmaorganics/data/entitites/address.dart';
import 'package:bheeshmaorganics/presentation/address/add_address_page.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final bool canEdit;
  final bool selected;
  final Function onDelete;
  const AddressCard(
    this.address, {
    super.key,
    this.selected = false,
    this.canEdit = false,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Colors.white : null,
        borderRadius: BorderRadius.circular(12),
        border: !selected
            ? Border.all(
                color: Colors.white,
              )
            : null,
      ),
      padding: const EdgeInsets.all(
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                address.type,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: selected ? Colors.black : Colors.white,
                    ),
              ),
              const SizedBox(
                width: 160,
              ),
              canEdit
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddAddressPage(
                                  address: address,
                                )));
                      },
                      child: const Icon(
                        FeatherIcons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(
                      width: 20,
                    ),
              canEdit
                  ? const SizedBox(
                      width: 12,
                    )
                  : const SizedBox(),
              canEdit
                  ? InkWell(
                      onTap: () {
                        onDelete();
                      },
                      child: const Icon(
                        FeatherIcons.trash,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(
                      width: 20,
                    ),
            ],
          ),
          Text(
            address.name,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '${address.doorNumber}, ${address.building}\n${address.landmark}\n${address.street}\n${address.city}\n${address.state} - ${address.pincode}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected ? Colors.black : Colors.white,
                ),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact: ',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.black : Colors.white,
                    ),
              ),
              Text(
                address.phoneNumber,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected ? Colors.black : Colors.white,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
