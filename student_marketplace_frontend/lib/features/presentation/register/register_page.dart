import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../core/on_generate_route.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool _shouldMainContainerExpand;
  late bool _keepSignedIn;

  @override
  void initState() {
    _shouldMainContainerExpand = false;
    _keepSignedIn = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(),
      body: Center(
        child: Material(
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
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ),
                    PlatformTextField(
                      hintText: "First Name",
                    ),
                    PlatformTextField(
                      hintText: "Last Name",
                    ),
                    PlatformTextField(
                      hintText: "Second Last Name (optional)",
                    ),
                    PlatformTextField(
                      hintText: "Faculty",
                    ),
                    PlatformTextField(
                      hintText: "E-mail",
                    ),
                    PlatformTextField(
                      hintText: "Password",
                    ),
                    PlatformTextField(
                      hintText: "Confirm Password",
                    ),
                    PlatformTextField(
                      hintText: "Password",
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
                          child: const Text("Sign In",
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
}
