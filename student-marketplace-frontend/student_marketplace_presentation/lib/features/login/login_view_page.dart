import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/config/on_generate_route.dart';
import '../../core/theme/colors.dart';
import '../authentication/auth_bloc.dart';
import '../authentication/auth_state.dart';
import '../home/home_view_page.dart';
import 'login_view_bloc.dart';
import 'login_view_state.dart';

import 'package:student_marketplace_business_logic/data/models/credentials_model.dart';

class LoginViewPage extends StatelessWidget {
  final TextEditingController _emailTextfieldController =
      TextEditingController();
  final TextEditingController _passwordTextfielController =
      TextEditingController();
  final FocusNode _passwordFieldFocusNode = FocusNode();

  LoginViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      cupertino: (context, platform) =>
          CupertinoPageScaffoldData(resizeToAvoidBottomInset: false),
      body: BlocConsumer<LoginViewBloc, LoginViewState>(
        listener: _onStateChangedListener,
        builder: (context, state) {
          if (state.status == LoginPageStatus.loginSuccesful) {
            return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
              if (authState.status == AuthStatus.authenticated) {
                // Form submitted succesful and authentication was succcesful
                return HomeViewPage();
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

  Widget _bodyWidget(BuildContext context, LoginViewState state) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login_background.png'),
              fit: BoxFit.cover)),
      child: Center(
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: ScreenUtil().setWidth(700),
            height: state.status == LoginPageStatus.emailSucces
                ? ScreenUtil().setHeight(650)
                : ScreenUtil().setHeight(520),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    "Let's log you in",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(50),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                PlatformTextField(
                  hintText: "E-mail",
                  controller: _emailTextfieldController,
                  autocorrect: false,
                  onChanged: (text) => BlocProvider.of<LoginViewBloc>(context)
                      .onEmailInputChanged(text),
                  onSubmitted: state.isEmailPrefixActive
                      ? (text) => BlocProvider.of<LoginViewBloc>(context)
                          .checkIfEmailIsRegistered(CredentialsModel(
                              email: _emailTextfieldController.text,
                              password: ''))
                      : null,
                  cupertino: (context, target) =>
                      _emailCupertinoTextFieldData(context, state),
                ),
                if (state.status == LoginPageStatus.emailSucces)
                  PlatformTextField(
                    focusNode: _passwordFieldFocusNode,
                    hintText: "Password",
                    autocorrect: false,
                    onChanged: (text) => BlocProvider.of<LoginViewBloc>(context)
                        .onPasswordInputChanged(text),
                    onSubmitted: state.isEmailPrefixActive
                        ? (text) =>
                            BlocProvider.of<LoginViewBloc>(context).signInUser(
                              CredentialsModel(
                                  email: _emailTextfieldController.text,
                                  password: _passwordTextfielController.text),
                            )
                        : null,
                    cupertino: (context, target) =>
                        _passwordCupertinoTextFieldData(context, state),
                    controller: _passwordTextfielController,
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(50),
                      child: PlatformIconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              BlocProvider.of<LoginViewBloc>(context)
                                  .changeKeepSignedIn(),
                          icon: Icon(
                            state.keepSignedIn
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: state.keepSignedIn
                                ? accentColor
                                : Colors.black12,
                          )),
                    ),
                    Text("Keep me signed in",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(40),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: ScreenUtil().setSp(40)),
                    ),
                    SizedBox(
                      child: PlatformTextButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(PageNames.registerPage),
                        child: Text("Register",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: accentColor)),
                      ),
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

  _onStateChangedListener(BuildContext context, LoginViewState state) {
    if (state.status == LoginPageStatus.loginSuccesful) {
      BlocProvider.of<AuthBloc>(context).onSignIn();
    } else if (state.status == LoginPageStatus.emailSucces) {
      _passwordFieldFocusNode.requestFocus();
    } else if (state.status == LoginPageStatus.loginFailed) {
      _passwordTextfielController.clear();
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
      BuildContext context, LoginViewState state) {
    return CupertinoTextFieldData(
      suffix: _getEmailTextFieldPrefix(context, state),
      padding: const EdgeInsets.only(left: 10),
      autocorrect: false,
      decoration: BoxDecoration(
          borderRadius: state.status == LoginPageStatus.emailSucces
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))
              : const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }

  Widget _getEmailTextFieldPrefix(BuildContext context, LoginViewState state) {
    if (state.status == LoginPageStatus.emailSubmitting) {
      return const SizedBox(height: 40, child: CupertinoActivityIndicator());
    }
    if (state.status == LoginPageStatus.emailSucces) {
      return const SizedBox(
        height: 40,
        child: Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: PlatformIconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(
          CupertinoIcons.arrow_right_circle,
          color: accentColor,
          size: 30,
        ),
        onPressed: state.isEmailPrefixActive
            ? () => BlocProvider.of<LoginViewBloc>(context)
                .checkIfEmailIsRegistered(CredentialsModel(
                    email: _emailTextfieldController.text, password: ''))
            : null,
      ),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextFieldData(
      BuildContext context, LoginViewState state) {
    return CupertinoTextFieldData(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            border: Border.all(
                color: state.status == LoginPageStatus.emailSucces
                    ? accentColor
                    : Colors.black12)),
        obscureText: true,
        suffix: SizedBox(
            height: 40,
            child: PlatformIconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.arrow_right_circle,
                  color: accentColor,
                  size: 30,
                ),
                onPressed: state.isPasswordPrefixActive
                    ? () => BlocProvider.of<LoginViewBloc>(context).signInUser(
                          CredentialsModel(
                              email: _emailTextfieldController.text,
                              password: _passwordTextfielController.text),
                        )
                    : null)),
        enableSuggestions: false,
        autocorrect: false);
  }
}
