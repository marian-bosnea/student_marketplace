import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_page_state.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../core/on_generate_route.dart';
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

  RegisterPage({super.key}) {
    for (var a in _fieldsPlaceholders) {
      _edittingControllers.add(TextEditingController());
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
          ? const Icon(
              Icons.check,
              color: Colors.green,
            )
          : null,
      prefix: const SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          Icons.email,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black12)),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextDataField(
      BuildContext context, RegisterPageState state) {
    return CupertinoTextFieldData(
      prefix: const SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          Icons.lock,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black12)),
    );
  }

  CupertinoTextFieldData _personalInfoCupertinoTextDataField(
      BuildContext context, RegisterPageState state, IconData iconData) {
    return CupertinoTextFieldData(
      prefix: SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          iconData,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.black12)),
    );
  }

  Widget _personalInfoForm(BuildContext context, RegisterPageState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            width: 50,
            height: 50,
            child: const Icon(Icons.photo),
          ),
          PlatformTextField(
            hintText: _fieldsPlaceholders[3],
            controller: _edittingControllers[3],
            cupertino: (contex, target) => _personalInfoCupertinoTextDataField(
                context, state, Icons.person),
          ),
          PlatformTextField(
            hintText: _fieldsPlaceholders[4],
            controller: _edittingControllers[4],
            cupertino: (contex, target) => _personalInfoCupertinoTextDataField(
                context, state, Icons.person),
          ),
          PlatformTextField(
            hintText: _fieldsPlaceholders[5],
            controller: _edittingControllers[5],
            cupertino: (contex, target) => _personalInfoCupertinoTextDataField(
                context, state, Icons.person),
          ),
          PlatformTextField(
            hintText: _fieldsPlaceholders[6],
            controller: _edittingControllers[6],
            cupertino: (contex, target) => _personalInfoCupertinoTextDataField(
                context, state, Icons.school),
          ),
        ],
      ),
    );
  }

  Widget _credentialsForm(BuildContext context, RegisterPageState state) {
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
            onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                .checkEmailForAvailability(text),
          ),
          PlatformTextField(
            hintText: _fieldsPlaceholders[1],
            controller: _edittingControllers[1],
            obscureText: true,
            cupertino: (contex, target) =>
                _passwordCupertinoTextDataField(context, state),
            onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                .checkIfPasswordIsValid(text),
          ),
          if (state.showPasswordWarning) getWarningText('Password too short'),
          PlatformTextField(
            hintText: _fieldsPlaceholders[2],
            controller: _edittingControllers[2],
            obscureText: true,
            cupertino: (contex, target) =>
                _passwordCupertinoTextDataField(context, state),
            onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                .checkIfPasswordsMatch(text),
          ),
          if (state.showConfirmPasswordWarning)
            getWarningText('Passwords do not match'),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, RegisterPageState state) {
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
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                    labels: ['Credentials', 'Profile'],
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
                    onPressed: state.status ==
                                RegisterPageStatus.validCredentials ||
                            state.status == RegisterPageStatus.validPersonalInfo
                        ? () => BlocProvider.of<RegisterCubit>(context)
                            .goToNextStep()
                        : null,
                  ),
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

  Widget getWarningText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: Colors.red),
    );
  }

  String _getFormTitle(RegisterPageState state) {
    final String credentialsMessage = "Let's create your account!";
    final String personalInfoMessage = "Complete your profile";

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

  List<String> _getFieldInputs() {
    List<String> inputs = [];
    for (var a in _edittingControllers) {
      inputs.add(a.text);
    }

    return inputs;
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
