import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';
import 'package:student_marketplace_presentation/features/address_list_view/widgets/address_list_item.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';

import 'own_addresses_view_bloc.dart';
import 'own_addresses_view_state.dart';

class OwnAddressesViewPage extends StatelessWidget {
  const OwnAddressesViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnAddressesViewBloc, OwnAddressesViewState>(
      listener: (context, state) =>
          BlocProvider.of<OwnAddressesViewBloc>(context).fetchAllAddresses(),
      builder: (context, state) {
        final bloc = BlocProvider.of<OwnAddressesViewBloc>(context);
        return PlatformScaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: PlatformAppBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            trailingActions: [
              PlatformTextButton(
                padding: EdgeInsets.zero,
                child: const Text(
                  'Add Address',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.createAddress),
              )
            ],
            cupertino: ((context, platform) => CupertinoNavigationBarData(
                automaticallyImplyLeading: true,
                previousPageTitle: 'My Profile')),
          ),
          body: state.addresses.isEmpty
              ? const Center(
                  child: EmptyListPlaceholder(
                      message: 'You have not set any address'),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 150,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    autoClose: false,
                                    onPressed: (context) =>
                                        Navigator.of(context).pushNamed(
                                            RouteNames.createAddress,
                                            arguments: state.addresses
                                                .elementAt(index)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: CupertinoIcons.pen,
                                    label: '',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) => bloc.deleteAddress(
                                        state.addresses.elementAt(index)),
                                    autoClose: false,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: CupertinoIcons.trash,
                                    label: '',
                                  ),
                                ]),
                            child: AddressListItem(
                              address: state.addresses.elementAt(index),
                            ),
                          ),
                        );
                      }),
                ),
        );
      },
    );
  }
}
