import 'package:flutter/material.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

class AddressListItem extends StatelessWidget {
  final AddressEntity address;

  const AddressListItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(
            address.name,
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          Row(
            children: [
              Text(
                'County: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              Text(
                address.county,
              )
            ],
          ),
          Row(
            children: [
              Text(
                'City: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              Text(
                address.city,
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Address: ',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              Text(
                address.description,
                maxLines: 3,
              )
            ],
          )
        ]),
      ),
    );
  }
}
