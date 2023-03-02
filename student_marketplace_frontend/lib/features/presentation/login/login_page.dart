import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/features/data/models/credentials_model.dart';
import 'package:student_marketplace_frontend/features/presentation/home/home_page.dart';
import '../../../core/on_generate_route.dart';
import '../authentication/auth_cubit.dart';
import '../authentication/auth_state.dart';
import 'login_cubit.dart';
import 'login_page_state.dart';

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
      backgroundColor: Colors.blue,
      body: BlocConsumer<LoginCubit, LoginPageState>(
        listener: _onStateChangedListener,
        builder: (context, state) {
          if (state.status == LoginPageStatus.loginSuccesful) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                // Form submitted succesful and authentication was succcesful
                return HomePage();
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: MediaQuery.of(context).size.width * 0.75,
          height: state.status == LoginPageStatus.emailSucces
              ? MediaQuery.of(context).size.height * 0.35
              : MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.only(top: 5, bottom: 20),
                child: const Text(
                  "Let's log you in",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
              PlatformTextField(
                hintText: "E-mail",
                controller: _emailTextfieldController,
                onChanged: (text) => BlocProvider.of<LoginCubit>(context)
                    .onEmailInputChanged(text),
                onSubmitted: state.isEmailPrefixActive
                    ? (text) => BlocProvider.of<LoginCubit>(context)
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
                  onChanged: (text) => BlocProvider.of<LoginCubit>(context)
                      .onPasswordInputChanged(text),
                  onSubmitted: state.isEmailPrefixActive
                      ? (text) =>
                          BlocProvider.of<LoginCubit>(context).signInUser(
                            CredentialsModel(
                                email: _emailTextfieldController.text,
                                password: _passwordTextfielController.text),
                          )
                      : null,
                  cupertino: (context, target) =>
                      _passwordCupertinoTextFieldData(context, state),
                  controller: _passwordTextfielController,
                ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 25,
                      child: PlatformIconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => BlocProvider.of<LoginCubit>(context)
                              .changeKeepSignedIn(),
                          icon: Icon(
                            state.keepSignedIn
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: state.keepSignedIn
                                ? Colors.blueAccent
                                : Colors.black12,
                          )),
                    ),
                    const Text("Keep me signed in",
                        style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  PlatformTextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(PageNames.registerPage),
                    child:
                        const Text("Register", style: TextStyle(fontSize: 16)),
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
    if (state.status == LoginPageStatus.loginSuccesful) {
      BlocProvider.of<AuthCubit>(context).onSignIn();
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
      BuildContext context, LoginPageState state) {
    return CupertinoTextFieldData(
      suffix: _getEmailTextFieldPrefix(context, state),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          borderRadius: state.status == LoginPageStatus.emailSucces
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))
              : const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }

  Widget _getEmailTextFieldPrefix(BuildContext context, LoginPageState state) {
    if (state.status == LoginPageStatus.emailSubmitting) {
      return SizedBox(height: 40, child: const CupertinoActivityIndicator());
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
          size: 30,
        ),
        onPressed: state.isEmailPrefixActive
            ? () => BlocProvider.of<LoginCubit>(context)
                .checkIfEmailIsRegistered(CredentialsModel(
                    email: _emailTextfieldController.text, password: ''))
            : null,
      ),
    );
  }

  CupertinoTextFieldData _passwordCupertinoTextFieldData(
      BuildContext context, LoginPageState state) {
    return CupertinoTextFieldData(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            border: Border.all(
                color: state.status == LoginPageStatus.emailSucces
                    ? Colors.blueAccent
                    : Colors.black12)),
        obscureText: true,
        suffix: SizedBox(
            height: 40,
            child: PlatformIconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.arrow_right_circle,
                  size: 30,
                ),
                onPressed: state.isPasswordPrefixActive
                    ? () => BlocProvider.of<LoginCubit>(context).signInUser(
                          CredentialsModel(
                              email: _emailTextfieldController.text,
                              password: _passwordTextfielController.text),
                        )
                    : null)),
        enableSuggestions: false,
        autocorrect: false);
  }
}
