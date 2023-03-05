import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/features/presentation/add_post/add_post_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/add_post/add_post_page_state.dart';

import '../register/register_page_state.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage({super.key});

  final _categoryTextfieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AddPostCubit>(context).fetchAllCategories();

    return BlocBuilder<AddPostCubit, AddPostPageState>(
      builder: (context, state) {
        return Material(
          child: Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Sell an item on Marketplace',
                    style: TextStyle(fontSize: 20),
                  ),
                  PlatformTextField(
                    hintText: 'Title',
                    onChanged: (text) => BlocProvider.of<AddPostCubit>(context)
                        .setTitleValue(text),
                    cupertino: (context, platform) =>
                        _personalInfoCupertinoTextDataField(
                            context, 0, Icons.title),
                  ),
                  PlatformTextField(
                    hintText: 'Description',
                    maxLines: 5,
                    onChanged: (text) => BlocProvider.of<AddPostCubit>(context)
                        .setDescriptionValue(text),
                    cupertino: (context, platform) =>
                        _personalInfoCupertinoTextDataField(
                            context, 1, Icons.description),
                  ),
                  PlatformTextField(
                    hintText: 'Price',
                    maxLines: 1,
                    onChanged: (text) => BlocProvider.of<AddPostCubit>(context)
                        .setPriceValue(text),
                    cupertino: (context, platform) =>
                        _personalInfoCupertinoTextDataField(
                            context, 2, Icons.price_change),
                  ),
                  PlatformTextField(
                    readOnly: true,
                    hintText: 'Select a category',
                    controller: _categoryTextfieldController,
                    onTap: () => _openDrowDownFacultiesList(state, context),
                    cupertino: (context, platform) =>
                        _personalInfoCupertinoTextDataField(
                            context, 3, Icons.category),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () => BlocProvider.of<AddPostCubit>(context)
                              .setPhotos(),
                          child: Card(
                            elevation: 5,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                child: state.images.length >= 1
                                    ? Image.memory(state.images[0])
                                    : const Icon(Icons.add_a_photo_outlined)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => BlocProvider.of<AddPostCubit>(context)
                              .setPhotos(),
                          child: Card(
                            elevation: 5,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                child: state.images.length >= 2
                                    ? Image.memory(state.images[1])
                                    : const Icon(Icons.add_a_photo_outlined)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => BlocProvider.of<AddPostCubit>(context)
                              .setPhotos(),
                          child: Card(
                            elevation: 5,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                child: state.images.length >= 3
                                    ? Image.memory(state.images[2])
                                    : const Icon(Icons.add_a_photo_outlined)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PlatformElevatedButton(
                    onPressed: () =>
                        BlocProvider.of<AddPostCubit>(context).uploadPost(),
                    child: const Text("List item"),
                  )
                ]),
          ),
        );
      },
    );
  }

  void _openDrowDownFacultiesList(
      AddPostPageState state, BuildContext context) {
    DropDownState(
      DropDown(
        bottomSheetTitle: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: _getListItemsData(state),
        selectedItems: (List<dynamic> selectedList) {
          final item = selectedList.first as SelectedListItem;
          BlocProvider.of<AddPostCubit>(context)
              .setCategoryValue(item.value!)
              .then((value) {
            _categoryTextfieldController.text = item.name;
          });
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  List<SelectedListItem> _getListItemsData(AddPostPageState state) {
    List<SelectedListItem> items = [];
    for (var c in state.categories) {
      items.add(
          SelectedListItem(name: c.name.toString(), value: c.id.toString()));
    }
    return items;
  }

  CupertinoTextFieldData _personalInfoCupertinoTextDataField(
      BuildContext context, int index, IconData iconData) {
    return CupertinoTextFieldData(
      prefix: Container(
        margin: const EdgeInsets.only(left: 5),
        child: Icon(
          iconData,
          size: 25,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
