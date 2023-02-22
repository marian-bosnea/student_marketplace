import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/presentation/login/login_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/login/login_page_state.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_page_state.dart';

import '../../../core/on_generate_route.dart';
import '../authentication/auth_cubit.dart';
import '../authentication/auth_state.dart';
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
      appBar: PlatformAppBar(),
      backgroundColor: Colors.amber,
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
              CupertinoIcons.check_mark,
              color: Colors.green,
            )
          : null,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          border: Border.all(
              color: state.showEmailCheckmark
                  ? Colors.blueAccent
                  : Colors.black12)),
    );
  }

  Widget _getBodyWidget(BuildContext context, RegisterPageState state) {
    print("Builder called!");

    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[0],
                  controller: _edittingControllers[0],
                  cupertino: (context, target) =>
                      _emailCupertinoTextFieldData(context, state),
                  onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                      .checkEmailForAvailability(text),
                ),
                //if (state.showEmailCheckmark)
                //getWarningText('Email is already taken'),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[1],
                  controller: _edittingControllers[1],
                  obscureText: true,
                  onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                      .checkIfPasswordIsValid(_getFieldInputs()),
                ),
                if (state.showPasswordWarning)
                  getWarningText('Password too short'),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[2],
                  controller: _edittingControllers[2],
                  obscureText: true,
                  onChanged: (text) => BlocProvider.of<RegisterCubit>(context)
                      .checkIfPasswordsMatch(_getFieldInputs()),
                ),
                if (state.showConfirmPasswordWarning)
                  getWarningText('Passwords do not match'),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[3],
                  controller: _edittingControllers[3],
                ),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[4],
                  controller: _edittingControllers[4],
                ),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[5],
                  controller: _edittingControllers[5],
                ),
                PlatformTextField(
                  hintText: _fieldsPlaceholders[6],
                  controller: _edittingControllers[6],
                ),
                SizedBox(
                  child: PlatformElevatedButton(
                    padding: const EdgeInsets.all(10),
                    child: const Text("Sign Up"),
                    onPressed: () => BlocProvider.of<RegisterCubit>(context)
                        .registerUser(_getFieldInputs()),
                  ),
                ),
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
                      child:
                          const Text("Sign In", style: TextStyle(fontSize: 13)),
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

  List<String> _getFieldInputs() {
    List<String> inputs = [];
    for (var a in _edittingControllers) {
      inputs.add(a.text);
    }

    return inputs;
  }

  _onStateChangedListener(BuildContext context, RegisterPageState state) {
    if (state.status == FormStatus.succesSubmission) {
    } else {}
  }
}
