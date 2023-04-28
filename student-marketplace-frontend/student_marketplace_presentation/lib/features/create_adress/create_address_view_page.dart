import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_marketplace_business_logic/domain/entities/address_entity.dart';
import 'package:student_marketplace_presentation/features/address_list_view/own_addresses_view_bloc.dart';

import '../../core/theme/colors.dart';
import 'create_address_view_bloc.dart';
import 'create_adress_view_state.dart';

class CreateAddressViewPage extends StatelessWidget {
  final AddressEntity? addressToEdit;

  final _nameController = TextEditingController();
  final _countyController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  CreateAddressViewPage({super.key, this.addressToEdit}) {
    if (addressToEdit != null) {
      _nameController.text = addressToEdit!.name;
      _cityController.text = addressToEdit!.city;
      _countyController.text = addressToEdit!.county;
      _descriptionController.text = addressToEdit!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAddressViewBloc()..init(addressToEdit),
      child: BlocBuilder<CreateAddressViewBloc, CreateAddressViewState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<CreateAddressViewBloc>(context);
          return PlatformScaffold(
            backgroundColor: Theme.of(context).primaryColor,
            cupertino: (context, platform) =>
                CupertinoPageScaffoldData(resizeToAvoidBottomInset: false),
            appBar: PlatformAppBar(
              backgroundColor: Theme.of(context).highlightColor,
              title: Text(
                addressToEdit != null ? 'Edit Address' : 'New Address',
                style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontWeight: FontWeight.w600),
              ),
              cupertino: ((context, platform) => CupertinoNavigationBarData(
                  automaticallyImplyLeading: true,
                  previousPageTitle: 'Addresses')),
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(50),
                height: ScreenUtil().setHeight(1500),
                child: ListView(children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(500),
                    child:
                        SvgPicture.asset('assets/images/add_address_art.svg'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    child: PlatformTextField(
                      hintText: 'Name',
                      controller: _nameController,
                      cupertino: (context, platform) =>
                          _cupertinoTextFieldData(context),
                      material: (context, platform) =>
                          _materialTextFieldData(context),
                      onChanged: (text) => bloc.setNameValue(text),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    child: PlatformTextField(
                      hintText: 'County',
                      controller: _countyController,
                      cupertino: (context, platform) =>
                          _cupertinoTextFieldData(context),
                      material: (context, platform) =>
                          _materialTextFieldData(context),
                      onChanged: (text) => bloc.setCountyValue(text),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    child: PlatformTextField(
                      hintText: 'City',
                      controller: _cityController,
                      cupertino: (context, platform) =>
                          _cupertinoTextFieldData(context),
                      material: (context, platform) =>
                          _materialTextFieldData(context),
                      onChanged: (text) => bloc.setCityValue(text),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    child: PlatformTextField(
                      hintText: 'Address',
                      controller: _descriptionController,
                      cupertino: (context, platform) =>
                          _cupertinoTextFieldData(context),
                      material: (context, platform) =>
                          _materialTextFieldData(context),
                      onChanged: (text) => bloc.setDescriptionValue(text),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(50),
                    child: PlatformElevatedButton(
                      cupertino: (context, platform) =>
                          CupertinoElevatedButtonData(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                      color: Theme.of(context).splashColor,
                      child: Text(
                        addressToEdit != null ? 'Edit Address' : 'New Address',
                      ),
                      onPressed: () async {
                        await bloc.submit(addressToEdit?.id);
                        await BlocProvider.of<OwnAddressesViewBloc>(context)
                            .fetchAllAddresses();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  CupertinoTextFieldData _cupertinoTextFieldData(BuildContext context) {
    return CupertinoTextFieldData(
      cursorColor: Theme.of(context).splashColor,
      style: Theme.of(context).textTheme.labelMedium,
      placeholderStyle: Theme.of(context).textTheme.displayMedium,
      decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }

  MaterialTextFieldData _materialTextFieldData(BuildContext context) {
    return MaterialTextFieldData(
        cursorColor: Theme.of(context).splashColor,
        decoration:
            InputDecoration(fillColor: Theme.of(context).highlightColor));
  }
}
