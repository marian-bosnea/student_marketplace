import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_marketplace_business_logic/data/models/credentials_model.dart';
import 'package:student_marketplace_presentation/features/register/register_view_state.dart';
import 'package:student_marketplace_presentation/features/register/register_view_bloc.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/colors.dart';
import '../login/login_view_page.dart';

@immutable
class RegisterViewPage extends StatelessWidget {
  final List<String> _fieldsPlaceholders = [
    'Email',
    'Password',
    'Confirm Password',
    'First Name',
    'Last Name',
    'Second Last Name(optional)',
    'Faculty'
  ];

  late final List<TextEditingController> _edittingControllers = [];

  final double textFieldHeight = 40;
  final double textFieldBorderRadius = 20;

  final titleStyle = TextStyle(fontSize: ScreenUtil().setSp(40));
  final _stepSvg = [
    SvgPicture.asset(
      'assets/images/credentials_art.svg',
    ),
    SvgPicture.asset(
      'assets/images/personal_info_art.svg',
    ),
    SvgPicture.asset(
      'assets/images/profile_image_art.svg',
    )
  ];

  RegisterViewPage({super.key}) {
    for (var a in _fieldsPlaceholders) {
      _edittingControllers.add(TextEditingController());
    }
  }
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        cupertino: ((context, platform) =>
            CupertinoNavigationBarData(previousPageTitle: 'Login')),
      ),
      body: BlocBuilder<RegisterViewBloc, RegisterViewState>(
        builder: (context, state) {
          if (state.status == FormStatus.succesSubmission) {
            return LoginViewPage();
          } else {
            return _getBodyWidget(context, state);
          }
        },
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, RegisterViewState state) {
    if (state.faculties.isEmpty) {
      BlocProvider.of<RegisterViewBloc>(context).fetchAllFaculties();
    }
    final bloc = BlocProvider.of<RegisterViewBloc>(context);
    return Material(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Theme(
          data: ThemeData(
            primaryColor: accentColor,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: accentColor,
                ),
          ),
          child: Stepper(
              currentStep: state.currentStep,
              type: StepperType.vertical,
              onStepContinue: () => bloc.goToNextStep(context),
              onStepCancel: () => bloc.goToPreviousStep(),
              controlsBuilder: ((context, details) => Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: ScreenUtil().setWidth(350),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              state.currentStep == 2 ? 'Register' : 'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        if (state.currentStep != 0)
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
                  )),
              steps: [
                Step(
                    title: Text(
                      'Credentials',
                      style: titleStyle,
                    ),
                    content: Column(
                      children: [
                        SizedBox(
                          width: ScreenUtil().setWidth(500),
                          height: ScreenUtil().setHeight(600),
                          child: _stepSvg[0],
                        ),
                        _credentialsForm(context, state),
                      ],
                    )),
                Step(
                    title: Text(
                      'Personal Info',
                      style: titleStyle,
                    ),
                    content: Column(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(500),
                          height: ScreenUtil().setHeight(600),
                          child: _stepSvg[1],
                        ),
                        _personalInfoForm(context, state),
                      ],
                    )),
                Step(
                    title: Text(
                      'Profile Photo',
                      style: titleStyle,
                    ),
                    content: Column(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(500),
                          height: ScreenUtil().setHeight(600),
                          child: _stepSvg[2],
                        ),
                        _getProfilePhotoForm(context, state),
                      ],
                    ))
              ]),
        ),
      ),
    );
  }

  CupertinoTextFieldData _emailCupertinoTextFieldData(
      BuildContext context, RegisterViewState state) {
    return CupertinoTextFieldData(
      suffix: state.showEmailCheckmark
          ? Container(
              margin: const EdgeInsets.only(right: 5),
              child: const Icon(
                Icons.check,
                color: Colors.green,
              ),
            )
          : null,
      prefix: Container(
        height: textFieldHeight,
        margin: const EdgeInsets.only(left: 5),
        child: const Icon(
          Icons.email,
          size: 25,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(textFieldBorderRadius)),
          border: Border.all(color: Colors.black12)),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextDataField(
      BuildContext context, RegisterViewState state) {
    return CupertinoTextFieldData(
      prefix: Container(
        height: textFieldHeight,
        margin: const EdgeInsets.only(left: 5),
        child: const Icon(
          Icons.lock,
          size: 25,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(textFieldBorderRadius)),
          border: Border.all(color: Colors.black12)),
    );
  }

  CupertinoTextFieldData _personalInfoCupertinoTextDataField(
      BuildContext context,
      RegisterViewState state,
      int index,
      IconData iconData) {
    return CupertinoTextFieldData(
      prefix: Container(
        height: textFieldHeight,
        margin: const EdgeInsets.only(left: 5),
        child: Icon(
          iconData,
          size: 25,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(textFieldBorderRadius)),
          border: Border.all(color: Colors.black12)),
    );
  }

  Widget _personalInfoForm(BuildContext context, RegisterViewState state) {
    BlocProvider.of<RegisterViewBloc>(context).fetchAllFaculties();
    return SizedBox(
      height: ScreenUtil().setHeight(400),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PlatformTextField(
              hintText: _fieldsPlaceholders[3],
              controller: _edittingControllers[3],
              onChanged: (text) =>
                  BlocProvider.of<RegisterViewBloc>(context).setFirstName(text),
              cupertino: ((context, platform) =>
                  _personalInfoCupertinoTextDataField(
                      context, state, 3, Icons.person_2)),
            ),
            PlatformTextField(
              hintText: _fieldsPlaceholders[4],
              controller: _edittingControllers[4],
              onChanged: (text) =>
                  BlocProvider.of<RegisterViewBloc>(context).setLastName(text),
              cupertino: ((context, platform) =>
                  _personalInfoCupertinoTextDataField(
                      context, state, 4, Icons.person_2)),
            ),
            PlatformTextField(
              hintText: _fieldsPlaceholders[5],
              controller: _edittingControllers[5],
              onSubmitted: (text) => _openDrowDownFacultiesList(state, context),
              onChanged: (text) => BlocProvider.of<RegisterViewBloc>(context)
                  .setSecondLastName(text),
              cupertino: ((context, platform) =>
                  _personalInfoCupertinoTextDataField(
                      context, state, 5, Icons.person_2)),
            ),
            PlatformTextField(
              hintText: _fieldsPlaceholders[6],
              controller: _edittingControllers[6],
              onTap: () => _openDrowDownFacultiesList(state, context),
              cupertino: ((context, platform) =>
                  _personalInfoCupertinoTextDataField(
                      context, state, 3, Icons.school)),
            ),
          ]),
    );
  }

  void _openDrowDownFacultiesList(
      RegisterViewState state, BuildContext context) {
    DropDownState(
      DropDown(
        bottomSheetTitle: const Text(
          'Faculties',
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
          BlocProvider.of<RegisterViewBloc>(context)
              .onSelectFaculty(item.value!)
              .then((value) {
            _edittingControllers[_edittingControllers.length - 1].text =
                item.name;
          });
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  List<SelectedListItem> _getListItemsData(RegisterViewState state) {
    List<SelectedListItem> items = [];
    for (var f in state.faculties) {
      items.add(
          SelectedListItem(name: f.name.toString(), value: f.id.toString()));
    }
    return items;
  }

  Widget _credentialsForm(BuildContext context, RegisterViewState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlatformTextField(
            hintText: _fieldsPlaceholders[0],
            controller: _edittingControllers[0],
            cupertino: (context, target) =>
                _emailCupertinoTextFieldData(context, state),
            onChanged: (text) => BlocProvider.of<RegisterViewBloc>(context)
                .checkEmailForAvailability(
                    CredentialsModel(email: text, password: '')),
          ),
          PlatformTextField(
            hintText: _fieldsPlaceholders[1],
            controller: _edittingControllers[1],
            obscureText: true,
            cupertino: (contex, target) =>
                _passwordCupertinoTextDataField(context, state),
            onChanged: (text) => BlocProvider.of<RegisterViewBloc>(context)
                .checkIfPasswordIsValid(text),
          ),
          if (state.showPasswordWarning) _getWarningText('Password too short'),
          PlatformTextField(
            hintText: _fieldsPlaceholders[2],
            controller: _edittingControllers[2],
            obscureText: true,
            cupertino: (contex, target) =>
                _passwordCupertinoTextDataField(context, state),
            onChanged: (text) => BlocProvider.of<RegisterViewBloc>(context)
                .checkIfPasswordsMatch(text),
          ),
          if (state.showConfirmPasswordWarning)
            _getWarningText('Passwords do not match'),
        ],
      ),
    );
  }

  Widget _getProfilePhotoForm(BuildContext context, RegisterViewState state) {
    return Container(
      child: Column(children: [
        GestureDetector(
          onTap: () =>
              BlocProvider.of<RegisterViewBloc>(context).onSelectImage(),
          child: SizedBox(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              child: CircleAvatar(
                radius: 105,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: state.hasUploadedPhoto
                      ? Image.memory(state.avatarImage!).image
                      : null,
                  child: const Icon(Icons.add_a_photo),
                ),
              )),
        ),
      ]),
    );
  }

  Widget _getWarningText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.red),
    );
  }
}
