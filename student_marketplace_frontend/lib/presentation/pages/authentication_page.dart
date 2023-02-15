import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../http_interface.dart';
import 'user_profile_page.dart';

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

  final HttpInterface httpInterface = HttpInterface();

  late FocusNode _passwordFieldFocusNode;

  late bool _shouldMainContainerExpand;
  late bool _showPasswordField;
  late bool _isEmailFieldFocused;
  late bool _isPasswordFieldFocused;
  late bool _canSignIn;
  late bool _keepSignedIn;

  @override
  void initState() {
    _passwordFieldFocusNode = FocusNode();

    _shouldMainContainerExpand = false;
    _showPasswordField = false;
    _isEmailFieldFocused = false;
    _isPasswordFieldFocused = false;
    _canSignIn = false;
    _keepSignedIn = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AnimatedContainer(
            width: 250,
            height: _shouldMainContainerExpand ? 220 : 180,
            curve: Curves.fastOutSlowIn,
            padding: const EdgeInsets.all(10),
            onEnd: () =>
                setState(() => _showPasswordField = _shouldMainContainerExpand),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            duration: const Duration(milliseconds: 500),
            child: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: const Text(
                    "Log in",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                PlatformTextField(
                  hintText: "E-mail",
                  controller: _emailTextfieldController,
                  cupertino: _emailCupertinoTextFieldData,
                  onChanged: (text) => _onEmailFieldTextChanged(),
                  onSubmitted: (text) => _onSubmitEmailField(),
                ),
                if (_showPasswordField)
                  PlatformTextField(
                    focusNode: _passwordFieldFocusNode,
                    hintText: "Password",
                    cupertino: _passwordCupertinoTextFieldData,
                    controller: _passwordTextfielController,
                    onChanged: (text) => _onPasswordTextChanged(text),
                    onSubmitted: (text) => _onLoginButtonPressed(context),
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
                                setState(() => _keepSignedIn = !_keepSignedIn),
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
                      onPressed: () => _onRegisterButtonPressed(),
                      child: const Text("Register",
                          style: TextStyle(fontSize: 13)),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @pragma("UI input handlers")
  _onLoginButtonPressed(BuildContext context) {
    httpInterface
        .logUser(
            _emailTextfieldController.text, _passwordTextfielController.text)
        .then((success) {
      if (success) {
        Navigator.of(context).push(platformPageRoute(
            context: context,
            builder: (context) {
              return UserProfilePage(
                httpInterface: httpInterface,
              );
            }));
      } else {
        _showIncorrectPasswordDialog(context);
      }
    });
  }

  _onEmailFieldTextChanged() {
    setState(() => _showPasswordField = false);
    setState(() => _shouldMainContainerExpand = false);
  }

  _onPasswordTextChanged(String text) =>
      setState(() => _canSignIn = text.isNotEmpty);

  _onSubmitEmailField() {
    final input = _emailTextfieldController.text;
    httpInterface.checkUserEmail(input).then((success) {
      if (success) {
        _passwordFieldFocusNode.requestFocus();
        _isPasswordFieldFocused = true;
        _isEmailFieldFocused = false;
      }

      setState(() => _shouldMainContainerExpand = success);
    });
  }

  _onRegisterButtonPressed() {}

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
            borderRadius: _showPasswordField
                ? const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))
                : const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                color:
                    _isEmailFieldFocused ? Colors.blueAccent : Colors.black12)),
        suffix: _shouldMainContainerExpand
            ? const SizedBox(
                height: 20,
                width: 30,
                child: Icon(CupertinoIcons.check_mark, color: Colors.green))
            : SizedBox(
                height: 20,
                width: 30,
                child: PlatformIconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(CupertinoIcons.arrow_right_circle,
                      color: Colors.black12),
                  onPressed: () => _onSubmitEmailField(),
                ),
              ));
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
        suffix: SizedBox(
          height: 20,
          width: 30,
          child: PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: Icon(CupertinoIcons.arrow_right_circle,
                color: _canSignIn ? Colors.black : Colors.black12),
            onPressed: _canSignIn ? () => _onLoginButtonPressed(context) : null,
          ),
        ),
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false);
  }
}
