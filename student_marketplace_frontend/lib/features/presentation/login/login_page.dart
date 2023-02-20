import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../core/enums.dart';
import '../../../core/on_generate_route.dart';
import '../authentication/auth_cubit.dart';
import '../authentication/auth_state.dart';
import 'login_cubit.dart';
import 'login_page_state.dart';
import '../user_profile/profile_page.dart';

import '../../data/models/user_model.dart';

class AuthenticationPage extends StatelessWidget {
  final TextEditingController _emailTextfieldController =
      TextEditingController();
  final TextEditingController _passwordTextfielController =
      TextEditingController();
  final FocusNode _passwordFieldFocusNode = FocusNode();

  AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.amber,
      body: BlocConsumer<LoginCubit, LoginPageState>(
        listener: _onStateChangedListener,
        builder: (context, state) {
          if (state.status == FormStatus.succesSubmission) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                // Form submitted succesful and authentication was succcesful
                return const ProfilePage();
              } else {
                // Form submitted succesful and authentication was not succcesful
                return _bodyWidget(context, state);
              }
            });
          }
          // Form not submitted
          return _bodyWidget(context, state);
        },
      ),
    );
  }

  Widget _bodyWidget(BuildContext context, LoginPageState state) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(10),
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
                      "Log in",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  PlatformTextField(
                    hintText: "E-mail",
                    controller: _emailTextfieldController,
                    onTap: () => BlocProvider.of<LoginCubit>(context)
                        .focusEmailTextField(),
                    cupertino: (context, target) =>
                        _emailCupertinoTextFieldData(context, state),
                    onChanged: (text) => BlocProvider.of<LoginCubit>(context)
                        .checkIfEmailIsRegistered(UserModel(email: text)),
                  ),
                  PlatformTextField(
                    focusNode: _passwordFieldFocusNode,
                    hintText: "Password",
                    onTap: () => BlocProvider.of<LoginCubit>(context)
                        .focusPasswordTextField(),
                    cupertino: (context, target) =>
                        _passwordCupertinoTextFieldData(context, state),
                    controller: _passwordTextfielController,
                  ),
                  SizedBox(
                    child: PlatformElevatedButton(
                      padding: const EdgeInsets.all(10),
                      onPressed: () => BlocProvider.of<LoginCubit>(context)
                          .signInUser(UserModel(
                              email: _emailTextfieldController.text,
                              password: _passwordTextfielController.text)),
                      child: const Text("Sign In"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25,
                          child: PlatformIconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  BlocProvider.of<LoginCubit>(context)
                                      .changeKeepSignedIn(),
                              icon: Icon(
                                state.keepSignedIn
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color:
                                    true ? Colors.blueAccent : Colors.black12,
                              )),
                        ),
                        const Text("Keep me signed in")
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 13),
                      ),
                      PlatformTextButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(PageNames.registerPage),
                        child: const Text("Register",
                            style: TextStyle(fontSize: 13)),
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  _onStateChangedListener(BuildContext context, LoginPageState state) {
    if (state.status == FormStatus.succesSubmission) {
      BlocProvider.of<AuthCubit>(context).onSignIn();
    } else if (state.status == FormStatus.failedSubmission) {
      _showIncorrectPasswordDialog(context);
    }
  }

  _showIncorrectPasswordDialog(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) {
          return PlatformAlertDialog(
            actions: [
              CupertinoDialogAction(
                child: const Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
            title: const Text("Incorrect Password"),
            content: const Text("The password you entered is incorrect."),
          );
        });
  }

  @pragma("Platform specific")
  CupertinoTextFieldData _emailCupertinoTextFieldData(
      BuildContext context, LoginPageState state) {
    return CupertinoTextFieldData(
      suffix: state.isEmailCorrect
          ? const Icon(
              CupertinoIcons.check_mark,
              color: Colors.green,
            )
          : null,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          border: Border.all(
              color: state.isEmailFieldFocused
                  ? Colors.blueAccent
                  : Colors.black12)),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextFieldData(
      BuildContext context, LoginPageState state) {
    return CupertinoTextFieldData(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            border: Border.all(
                color: state.isPasswordFieldFocused
                    ? Colors.blueAccent
                    : Colors.black12)),
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false);
  }
}
