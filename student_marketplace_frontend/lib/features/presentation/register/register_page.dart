import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_page_state.dart';

import '../../../core/on_generate_route.dart';

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

  late List<TextEditingController> _edittingControllers = [];

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(),
      backgroundColor: Colors.amber,
      body: Center(
        child: BlocConsumer<RegisterCubit, RegisterPageState>(
          listener: _onStateChangedListener,
          builder: (context, state) {
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
                      children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            )
                          ] +
                          _generateInputFields(context, state) +
                          <Widget>[
                            SizedBox(
                              child: PlatformElevatedButton(
                                padding: const EdgeInsets.all(10),
                                child: const Text("Sign In"),
                                onPressed: () =>
                                    BlocProvider.of<RegisterCubit>(context)
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
                                  child: const Text("Sign In",
                                      style: TextStyle(fontSize: 13)),
                                )
                              ],
                            )
                          ]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _generateInputFields(
      BuildContext context, RegisterPageState state) {
    List<Widget> fields = [];
    for (int i = 0; i < _fieldsPlaceholders.length; i++) {
      _edittingControllers.add(TextEditingController());

      fields.add(PlatformTextField(
        hintText: _fieldsPlaceholders[i],
        controller: _edittingControllers[i],
        cupertino: i == 0
            ? (context, target) => _emailCupertinoTextFieldData(context, state)
            : null,
        onChanged: i == 0
            ? (text) => BlocProvider.of<RegisterCubit>(context)
                .checkEmailForAvailability(text)
            : null,
      ));
    }
    return fields;
  }

  CupertinoTextFieldData _emailCupertinoTextFieldData(
      BuildContext context, RegisterPageState state) {
    return CupertinoTextFieldData(
      suffix: state.isEmailAvailable
          ? const Icon(
              CupertinoIcons.check_mark,
              color: Colors.green,
            )
          : null,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          border: Border.all(
              color:
                  state.isEmailAvailable ? Colors.blueAccent : Colors.black12)),
    );
  }

  List<String> _getFieldInputs() {
    List<String> inputs = [];
    for (var a in _edittingControllers) {
      inputs.add(a.text);
    }

    return inputs;
  }

  _onStateChangedListener(BuildContext context, RegisterPageState state) {}
}
