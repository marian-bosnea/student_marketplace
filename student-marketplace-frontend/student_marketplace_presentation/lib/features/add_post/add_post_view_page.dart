import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';
import '../../core/config/injection_container.dart' as di;

import '../shared/circle_button.dart';
import 'add_post_view_bloc.dart';
import 'add_post_view_state.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage({super.key});

  final _categoryTextfieldController = TextEditingController();
  final titleStyle = TextStyle(fontSize: ScreenUtil().setSp(40));
  final singleLineFieldHeight = ScreenUtil().setWidth(70);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPostViewBloc(
          uploadPostUsecase: di.sl.call(),
          getAllCategoriesUsecase: di.sl.call())
        ..fetchAllCategories(),
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
      child: Theme(
        data: ThemeData(
          primaryColor: accentColor,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: accentColor,
              ),
        ),
        child: Stepper(
            physics: const NeverScrollableScrollPhysics(),
            currentStep: state.currentStep,
            onStepContinue: () => bloc.goToNextStep(),
            onStepCancel: () => bloc.goToPreviousStep(),
            //onStepTapped: (step) => bloc.setCurrentStep(step),
            controlsBuilder: (context, details) => Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: ScreenUtil().setWidth(400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (bloc.canGoToNextStep())
                        PlatformElevatedButton(
                          color: accentColor,
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5, top: 5),
                          cupertino: ((context, platform) =>
                              CupertinoElevatedButtonData(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)))),
                          onPressed: details.onStepContinue,
                          child: Text(
                            state.currentStep == 4 ? 'Post your item' : 'Next',
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
                          child: const Text(
                            'Back',
                            style: TextStyle(color: accentColor),
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
                    style: titleStyle,
                  ),
                  content: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Try to include esential words that describe your item the best',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      SizedBox(
                        height: singleLineFieldHeight,
                        child: PlatformTextField(
                          onChanged: (text) => bloc.setTitleValue(text),
                          cupertino: (context, platform) =>
                              _personalInfoCupertinoTextDataField(context),
                        ),
                      ),
                    ],
                  )),
              Step(
                  isActive: state.currentStep == 1,
                  title: Text(
                    'Tell us more about you object',
                    style: titleStyle,
                  ),
                  content: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Describe your product as detailed as you can. Include details about its condition, features, color, sizes, etc',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      PlatformTextField(
                        maxLines: 5,
                        onChanged: (text) =>
                            BlocProvider.of<AddPostViewBloc>(context)
                                .setDescriptionValue(text),
                        cupertino: (context, platform) =>
                            _personalInfoCupertinoTextDataField(context),
                      ),
                    ],
                  )),
              Step(
                  isActive: state.currentStep == 2,
                  title: Text(
                    'What is the price?',
                    style: titleStyle,
                  ),
                  content: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Decide how much is your item worth. Take into account its grade of wear, how old it is, etc',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      SizedBox(
                        height: singleLineFieldHeight,
                        child: PlatformTextField(
                          maxLines: 1,
                          keyboardType: const TextInputType.numberWithOptions(),
                          onChanged: (text) =>
                              BlocProvider.of<AddPostViewBloc>(context)
                                  .setPriceValue(text),
                          cupertino: (context, platform) =>
                              _personalInfoCupertinoTextDataField(context),
                        ),
                      ),
                    ],
                  )),
              Step(
                  isActive: state.currentStep == 3,
                  title: Text(
                    'What category does the item belongs to?',
                    style: titleStyle,
                  ),
                  content: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Select the most appropriate category for your item. This will help others find your product more easily.',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      SizedBox(
                        height: singleLineFieldHeight,
                        child: PlatformTextField(
                          readOnly: true,
                          hintText: 'Select a category',
                          controller: _categoryTextfieldController,
                          onTap: () =>
                              _openDrowDownFacultiesList(state, context),
                          cupertino: (context, platform) =>
                              _personalInfoCupertinoTextDataField(context),
                        ),
                      ),
                    ],
                  )),
              Step(
                  isActive: state.currentStep == 4,
                  title: Text(
                    'Add some photos',
                    style: titleStyle,
                  ),
                  content: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Besides you description, you will need to add at least on photo to detail your post. Try to add  clear photos and include only the item you want to sell to avoid confusion.',
                          style: TextStyle(color: Colors.black38),
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
            _categoryTextfieldController.text = item.name;
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
      cursorColor: accentColor,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
