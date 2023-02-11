import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/networking/http_interface.dart';

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

  late bool _shouldMainContainerExpand;
  late bool _showAllContent;

  @override
  void initState() {
    _shouldMainContainerExpand = false;
    _showAllContent = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: null,
      backgroundColor: Colors.white70,
      body: Center(
        child: AnimatedContainer(
          width: 250,
          height: _shouldMainContainerExpand ? 200 : 100,
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.all(10),
          onEnd: () =>
              setState(() => _showAllContent = _shouldMainContainerExpand),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 0.25, color: Colors.black)),
          duration: const Duration(milliseconds: 500),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: const Text(
                "Let's log you in!",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: PlatformTextField(
                hintText: "Enter your e-mail",
                controller: _emailTextfieldController,
                cupertino: _emailCupertinoTextFieldData,
                onChanged: (text) => _onEmailFieldTextChanged(),
                onSubmitted: (text) => _onSubmitEmailField(text),
              ),
            ),
            if (_showAllContent)
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: PlatformTextField(
                  hintText: "Enter your password",
                  cupertino: _passwordCupertinoTextFieldData,
                  controller: _passwordTextfielController,
                ),
              ),
            if (_showAllContent)
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: PlatformTextButton(
                  onPressed: () => _onLoginButtonPressed(context),
                  child: const Text(
                    "Login",
                  ),
                ),
              )
          ]),
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
      } else {
        _showIncorrectPasswordDialog(context);
      }
    });
  }

  _onEmailFieldTextChanged() {
    setState(() => _showAllContent = false);
    setState(() => _shouldMainContainerExpand = false);
  }

  _onSubmitEmailField(input) {
    httpInterface.checkUserEmail(input).then((succes) {
      setState(() => _shouldMainContainerExpand = succes);
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
        suffix: _shouldMainContainerExpand
            ? const Icon(CupertinoIcons.check_mark, color: Colors.green)
            : null);
  }

  CupertinoTextFieldData _passwordCupertinoTextFieldData(
      BuildContext context, PlatformTarget target) {
    return CupertinoTextFieldData(
        obscureText: true, enableSuggestions: false, autocorrect: false);
  }
}
