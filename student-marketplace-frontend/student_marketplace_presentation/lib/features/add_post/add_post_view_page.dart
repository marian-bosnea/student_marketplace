import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
import '../../core/config/injection_container.dart' as di;

import 'add_post_view_bloc.dart';
import 'add_post_view_state.dart';

class AddPostPage extends StatelessWidget {
  final SalePostEntity? postToEdit;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  AddPostPage({super.key, this.postToEdit}) {
    if (postToEdit != null) {
      _titleController.text = postToEdit!.title;
      _descriptionController.text = postToEdit!.description!;
      _priceController.text = postToEdit!.price;
      _categoryController.text = postToEdit!.categoryName!;
    }
  }

  final singleLineFieldHeight = ScreenUtil().setWidth(70);
  final _stepSvg = [
    SvgPicture.asset('assets/images/sell_title_art.svg'),
    SvgPicture.asset('assets/images/sell_details_art.svg'),
    SvgPicture.asset('assets/images/sell_price_art.svg'),
    SvgPicture.asset('assets/images/sell_category_art.svg'),
    SvgPicture.asset('assets/images/sell_photos_art.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPostViewBloc(
          uploadPostUsecase: di.sl.call(),
          getAllCategoriesUsecase: di.sl.call())
        ..init(postToEdit),
      child: BlocBuilder<AddPostViewBloc, AddPostState>(
        builder: (context, state) {
          return getStepperForm(context, state);
        },
      ),
    );
  }

  Widget getStepperForm(BuildContext context, AddPostState state) {
    final bloc = BlocProvider.of<AddPostViewBloc>(context);

    return Material(
      color: Theme.of(context).primaryColor,
      child: Theme(
        data: ThemeData(
          primaryColor: Theme.of(context).splashColor,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Theme.of(context).splashColor,
              ),
        ),
        child: Stepper(
            physics: const NeverScrollableScrollPhysics(),
            currentStep: state.currentStep,
            onStepContinue: () => bloc.goToNextStep(context),
            onStepCancel: () => bloc.goToPreviousStep(),
            controlsBuilder: (context, details) => Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: ScreenUtil().setWidth(300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (bloc.canGoToNextStep())
                        PlatformElevatedButton(
                          color: Theme.of(context).splashColor,
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5, top: 5),
                          cupertino: ((context, platform) =>
                              CupertinoElevatedButtonData(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)))),
                          onPressed: details.onStepContinue,
                          child: Text(
                            state.currentStep == 4
                                ? (postToEdit != null
                                    ? 'Save Changes'
                                    : 'Post your item')
                                : 'Next',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      if (details.currentStep > 0)
                        PlatformElevatedButton(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5, top: 5),
                          cupertino: ((context, platform) =>
                              CupertinoElevatedButtonData(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)))),
                          onPressed: details.onStepCancel,
                          child: Text(
                            'Back',
                            style:
                                TextStyle(color: Theme.of(context).splashColor),
                          ),
                        )
                    ],
                  ),
                ),
            steps: [
              Step(
                  isActive: state.currentStep == 0,
                  title: Text(
                    'What do you want to sell?',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        SizedBox(
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setHeight(300),
                            child: _stepSvg[0]),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Try to include esential words that describe your item the best',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        SizedBox(
                          height: singleLineFieldHeight,
                          child: PlatformTextField(
                            controller: _titleController,
                            onChanged: (text) => bloc.setTitleValue(text),
                            cupertino: (context, platform) =>
                                _personalInfoCupertinoTextDataField(context),
                          ),
                        ),
                      ],
                    ),
                  )),
              Step(
                  isActive: state.currentStep == 1,
                  title: Text(
                    'Tell us more about you object',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setHeight(300),
                            child: _stepSvg[1]),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Describe your product as detailed as you can. Include details about its condition, features, color, sizes, etc',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        PlatformTextField(
                          controller: _descriptionController,
                          maxLines: 5,
                          onChanged: (text) =>
                              BlocProvider.of<AddPostViewBloc>(context)
                                  .setDescriptionValue(text),
                          cupertino: (context, platform) =>
                              _personalInfoCupertinoTextDataField(context),
                        ),
                      ],
                    ),
                  )),
              Step(
                  isActive: state.currentStep == 2,
                  title: Text(
                    'What is the price?',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setHeight(300),
                            child: _stepSvg[2]),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Decide how much is your item worth. Take into account its grade of wear, how old it is, etc',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        SizedBox(
                          height: singleLineFieldHeight,
                          child: PlatformTextField(
                            controller: _priceController,
                            maxLines: 1,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            onChanged: (text) =>
                                BlocProvider.of<AddPostViewBloc>(context)
                                    .setPriceValue(text),
                            cupertino: (context, platform) =>
                                _personalInfoCupertinoTextDataField(context),
                          ),
                        ),
                      ],
                    ),
                  )),
              Step(
                  isActive: state.currentStep == 3,
                  title: Text(
                    'What category does the item belongs to?',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setHeight(300),
                            child: _stepSvg[3]),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Select the most appropriate category for your item. This will help others find your product more easily.',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        SizedBox(
                          height: singleLineFieldHeight,
                          child: PlatformTextField(
                            readOnly: true,
                            hintText: 'Select a category',
                            controller: _categoryController,
                            onTap: () =>
                                _openDrowDownFacultiesList(state, context),
                            cupertino: (context, platform) =>
                                _personalInfoCupertinoTextDataField(context),
                          ),
                        ),
                      ],
                    ),
                  )),
              Step(
                  isActive: state.currentStep == 4,
                  title: Text(
                    'Add some photos',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            width: ScreenUtil().setWidth(300),
                            height: ScreenUtil().setHeight(300),
                            child: _stepSvg[4]),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Besides you description, you will need to add at least on photo to detail your post. Try to add  clear photos and include only the item you want to sell to avoid confusion.',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(400),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    BlocProvider.of<AddPostViewBloc>(context)
                                        .setPhotos(),
                                child: Card(
                                  elevation: 5,
                                  color: Theme.of(context).highlightColor,
                                  child: SizedBox(
                                      width: ScreenUtil().setWidth(400),
                                      child: state.images.isNotEmpty
                                          ? Image.memory(state.images[0])
                                          : const Icon(
                                              Icons.add_a_photo_outlined)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    BlocProvider.of<AddPostViewBloc>(context)
                                        .setPhotos(),
                                child: Card(
                                  elevation: 5,
                                  color: Theme.of(context).highlightColor,
                                  child: SizedBox(
                                      width: ScreenUtil().setWidth(400),
                                      child: state.images.length >= 2
                                          ? Image.memory(state.images[1])
                                          : const Icon(
                                              Icons.add_a_photo_outlined)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    BlocProvider.of<AddPostViewBloc>(context)
                                        .setPhotos(),
                                child: Card(
                                  elevation: 5,
                                  color: Theme.of(context).highlightColor,
                                  child: SizedBox(
                                      width: ScreenUtil().setWidth(400),
                                      child: state.images.length >= 3
                                          ? Image.memory(state.images[2])
                                          : const Icon(
                                              Icons.add_a_photo_outlined)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ]),
      ),
    );
  }

  void _openDrowDownFacultiesList(AddPostState state, BuildContext context) {
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
          BlocProvider.of<AddPostViewBloc>(context)
              .setCategoryValue(int.parse(item.value!))
              .then((value) {
            _categoryController.text = item.name;
          });
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  List<SelectedListItem> _getListItemsData(AddPostState state) {
    List<SelectedListItem> items = [];
    for (var c in state.categories) {
      items.add(
          SelectedListItem(name: c.name.toString(), value: c.id.toString()));
    }
    return items;
  }

  CupertinoTextFieldData _personalInfoCupertinoTextDataField(
      BuildContext context) {
    return CupertinoTextFieldData(
      cursorColor: Theme.of(context).splashColor,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
