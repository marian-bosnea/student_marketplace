import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_business_logic/data/models/credentials_model.dart';
import 'package:student_marketplace_presentation/features/register/register_cubit.dart';
import 'package:student_marketplace_presentation/features/register/register_page_state.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../core/constants/enums.dart';
import '../../core/config/on_generate_route.dart';
import '../login/login_page.dart';

@immutable
class RegisterPage extends StatelessWidget {
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
  late final List<FocusNode> _focusNodes = [];

  final double textFieldHeight = 40;
  final double textFieldBorderRadius = 20;

  RegisterPage({super.key}) {
    for (var a in _fieldsPlaceholders) {
      _edittingControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: BlocConsumer<RegisterCubit, RegisterPageState>(
          listener: _onStateChangedListener,
          builder: (context, state) {
            if (state.status == FormStatus.succesSubmission) {
              return AuthenticationPage();
            } else {
              return _getBodyWidget(context, state);
            }
          },
        ),
      ),
    );
  }

  CupertinoTextFieldData _emailCupertinoTextFieldData(
      BuildContext context, RegisterPageState state) {
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
          border: Border.all(
              color: _focusNodes[0].hasFocus ? Colors.blue : Colors.black12)),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextDataField(
      BuildContext context, RegisterPageState state) {
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
          border: Border.all(
              color: _focusNodes[1].hasFocus ? Colors.blue : Colors.black12)),
    );
  }

  CupertinoTextFieldData _personalInfoCupertinoTextDataField(
      BuildContext context,
      RegisterPageState state,
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
          border: Border.all(
              color: _focusNodes[index].hasPrimaryFocus
                  ? Colors.blue
                  : Colors.black12)),
    );
  }

  Widget _personalInfoForm(BuildContext context, RegisterPageState state) {
    BlocProvider.of<RegisterCubit>(context).fetchAllFaculties();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  BlocProvider.of<RegisterCubit>(context).onSelectImage(),
              child: SizedBox(
                  width: 100,
                  height: 100,
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
            PlatformTextField(
              focusNode: _focusNodes[3],
              hintText: _fieldsPlaceholders[3],
              controller: _edittingControllers[3],
              onChanged: (text) =>
                  BlocProvider.of<RegisterCubit>(context).setFirstName(text),
              onSubmitted: (text) => _focusNodes[4].requestFocus(),
              cupertino: ((context, platform) =>
                  _personalInfoCupertinoTextDataField(
                      context, state, 3, Icons.person_2)),
            ),
            PlatformTextField(
              focusNode: _focusNodes[4],
              hintText: _fieldsPlaceholders[4],
              controller: _edittingControllers[4],
              onSubmitted: (text) => _focusNodes[5].requestFocus(),
              onChanged: (text) =>
                  BlocProvider.of<RegisterCubit>(context).setLastName(text),
              cupertino: ((context, platform) =>
                  _personalInfoCupertinoTextDataField(
                      context, state, 4, Icons.person_2)),
            ),
            PlatformTextField(
              focusNode: _focusNodes[5],
              hintText: _fieldsPlaceholders[5],
              controller: _edittingControllers[5],
              onSubmitted: (text) => _openDrowDownFacultiesList(state, context),
              onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
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
      RegisterPageState state, BuildContext context) {
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
          BlocProvider.of<RegisterCubit>(context)
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

  List<SelectedListItem> _getListItemsData(RegisterPageState state) {
    List<SelectedListItem> items = [];
    for (var f in state.faculties) {
      items.add(
          SelectedListItem(name: f.name.toString(), value: f.id.toString()));
    }
    return items;
  }

  Widget _credentialsForm(BuildContext context, RegisterPageState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlatformTextField(
            hintText: _fieldsPlaceholders[0],
            focusNode: _focusNodes[0],
            controller: _edittingControllers[0],
            onSubmitted: (text) => _focusNodes[1].requestFocus(),
            cupertino: (context, target) =>
                _emailCupertinoTextFieldData(context, state),
            onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                .checkEmailForAvailability(
                    CredentialsModel(email: text, password: '')),
          ),
          PlatformTextField(
            focusNode: _focusNodes[1],
            hintText: _fieldsPlaceholders[1],
            controller: _edittingControllers[1],
            obscureText: true,
            cupertino: (contex, target) =>
                _passwordCupertinoTextDataField(context, state),
            onSubmitted: (text) => _focusNodes[2].requestFocus(),
            onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                .checkIfPasswordIsValid(text),
          ),
          if (state.showPasswordWarning) _getWarningText('Password too short'),
          PlatformTextField(
            focusNode: _focusNodes[2],
            hintText: _fieldsPlaceholders[2],
            controller: _edittingControllers[2],
            obscureText: true,
            cupertino: (contex, target) =>
                _passwordCupertinoTextDataField(context, state),
            onSubmitted: (text) {
              if (state.status == RegisterPageStatus.validCredentials ||
                  state.status == RegisterPageStatus.validPersonalInfo) {
                BlocProvider.of<RegisterCubit>(context).goToNextStep();
                _focusNodes[3].requestFocus();
              }
            },
            onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                .checkIfPasswordsMatch(text),
          ),
          if (state.showConfirmPasswordWarning)
            _getWarningText('Passwords do not match'),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, RegisterPageState state) {
    if (state.faculties.isEmpty) {
      BlocProvider.of<RegisterCubit>(context).fetchAllFaculties();
    }
    return Material(
      elevation: 2,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    _getFormTitle(state),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: ToggleSwitch(
                    minWidth: 100.0,
                    cornerRadius: 20.0,
                    activeBgColors: const [
                      [Colors.blue],
                      [Colors.blue]
                    ],
                    animate: true,
                    curve: Curves.decelerate,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.black12,
                    inactiveFgColor: Colors.black,
                    initialLabelIndex: state.status ==
                            RegisterPageStatus.personalInfoInProgress
                        ? 1
                        : 0,
                    totalSwitches: 2,
                    labels: const ['Credentials', 'Profile'],
                    radiusStyle: true,
                    onToggle: (index) {
                      if (index == 0) {
                        BlocProvider.of<RegisterCubit>(context)
                            .goToPreviousStep();
                      }
                    },
                  ),
                ),
                _getCurrentForm(context, state),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: PlatformIconButton(
                      padding: EdgeInsets.zero,
                      cupertinoIcon: const Icon(
                        CupertinoIcons.arrow_right_circle,
                        size: 40,
                      ),
                      materialIcon: const Icon(
                        Icons.arrow_right_rounded,
                        size: 40,
                      ),
                      onPressed: () {
                        if (state.status ==
                                RegisterPageStatus.validCredentials ||
                            state.status ==
                                RegisterPageStatus.validPersonalInfo) {
                          BlocProvider.of<RegisterCubit>(context)
                              .goToNextStep();
                          _focusNodes[3].requestFocus();
                        }
                        if (state.status ==
                            RegisterPageStatus.validPersonalInfo) {
                          BlocProvider.of<RegisterCubit>(context)
                              .registerUser()
                              .then((value) {
                            Navigator.of(context).pushReplacement(
                                platformPageRoute(
                                    context: context,
                                    builder: (context) =>
                                        AuthenticationPage()));
                          });
                        }
                      }),
                ),
                if (state.status != RegisterPageStatus.personalInfoInProgress)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 13),
                      ),
                      PlatformTextButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(PageNames.authenticationPage),
                        child: const Text("Sign In",
                            style: TextStyle(fontSize: 13)),
                      )
                    ],
                  )
              ]),
        ),
      ),
    );
  }

  Widget _getWarningText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.red),
    );
  }

  String _getFormTitle(RegisterPageState state) {
    const String credentialsMessage = "Let's create your account!";
    const String personalInfoMessage = "Complete your profile";

    switch (state.status) {
      case RegisterPageStatus.validCredentials:
        return credentialsMessage;
      case RegisterPageStatus.credentialsInProgress:
        return credentialsMessage;
      case RegisterPageStatus.personalInfoInProgress:
        return personalInfoMessage;
      case RegisterPageStatus.validPersonalInfo:
        return personalInfoMessage;
      case RegisterPageStatus.submissionSuccessful:
        return personalInfoMessage;
      case RegisterPageStatus.submissionFailed:
        return personalInfoMessage;
    }
  }

  Widget _getCurrentForm(BuildContext context, RegisterPageState state) {
    if (state.status == RegisterPageStatus.credentialsInProgress ||
        state.status == RegisterPageStatus.validCredentials) {
      return _credentialsForm(context, state);
    }
    return _personalInfoForm(context, state);
  }

  _onStateChangedListener(BuildContext context, RegisterPageState state) {}
}
