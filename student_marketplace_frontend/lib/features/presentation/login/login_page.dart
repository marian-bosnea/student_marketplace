import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../core/on_generate_route.dart';
import '../authentication/auth_cubit.dart';
import '../authentication/auth_state.dart';
import 'login_cubit.dart';
import 'login_form_submission_status.dart';
import 'login_state.dart';
import '../user_profile/profile_page.dart';

import '../../data/models/user_model.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailTextfieldController =
      TextEditingController();
  final TextEditingController _passwordTextfielController =
      TextEditingController();

  late FocusNode _passwordFieldFocusNode;

  late bool _isEmailFieldFocused;
  late bool _isPasswordFieldFocused;
  late bool _keepSignedIn;

  @override
  void initState() {
    _passwordFieldFocusNode = FocusNode();

    _isEmailFieldFocused = false;
    _isPasswordFieldFocused = false;
    _keepSignedIn = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.amber,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, loginState) {
          if (loginState.status is SubmissionSuccess) {
            BlocProvider.of<AuthCubit>(context).onSignIn();
          } else if (loginState.status is SubmissionFailed) {
            _showIncorrectPasswordDialog(context);
          }
        },
        builder: (context, state) {
          if (state.status is SubmissionSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                // Form submitted succesful and authentication was succcesful
                return const ProfilePage();
              } else {
                // Form submitted succesful and authentication was not succcesful
                return _bodyWidget();
              }
            });
          }
          // Form not submitted
          return _bodyWidget();
        },
      ),
    );
  }

  Widget _bodyWidget() {
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
                    cupertino: _emailCupertinoTextFieldData,
                  ),
                  PlatformTextField(
                    focusNode: _passwordFieldFocusNode,
                    hintText: "Password",
                    cupertino: _passwordCupertinoTextFieldData,
                    controller: _passwordTextfielController,
                  ),
                  SizedBox(
                    child: PlatformElevatedButton(
                      padding: const EdgeInsets.all(10),
                      onPressed: () => _onLoginButtonPressed(),
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
                              onPressed: () => setState(
                                  () => _keepSignedIn = !_keepSignedIn),
                              icon: Icon(
                                _keepSignedIn
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: _keepSignedIn
                                    ? Colors.blueAccent
                                    : Colors.black12,
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

  _onLoginButtonPressed() {
    BlocProvider.of<LoginCubit>(context)
        .signInUser(UserModel(
            email: _emailTextfieldController.text,
            password: _passwordTextfielController.text))
        .then((value) {
      _clear();
    });
  }

  _clear() {
    setState(() {
      _emailTextfieldController.clear();
      _passwordTextfielController.clear();
    });
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
      BuildContext context, PlatformTarget target) {
    return CupertinoTextFieldData(
      onTap: () => setState(() {
        _isEmailFieldFocused = true;
        _isPasswordFieldFocused = false;
      }),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          border: Border.all(
              color:
                  _isEmailFieldFocused ? Colors.blueAccent : Colors.black12)),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextFieldData(
      BuildContext context, PlatformTarget target) {
    return CupertinoTextFieldData(
        onTap: () => setState(() {
              _isPasswordFieldFocused = true;
              _isEmailFieldFocused = false;
            }),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            border: Border.all(
                color: _isPasswordFieldFocused
                    ? Colors.blueAccent
                    : Colors.black12)),
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false);
  }
}
