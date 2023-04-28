import 'package:flutter/material.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';

class AddressListItem extends StatelessWidget {
  final AddressEntity address;

  const AddressListItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      height: 100,
      child: Material(
        color: Theme.of(context).highlightColor,
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Text(
              address.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              children: [
                Text(
                  'County: ',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  address.county,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'City: ',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  address.city,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Address: ',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  address.description,
                  maxLines: 3,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
