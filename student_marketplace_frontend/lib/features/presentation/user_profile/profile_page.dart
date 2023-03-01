import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'profile_page_state.dart';

import '../authentication/auth_cubit.dart';
import 'profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfileCubit>(context).fetchUserProfile();
    return PlatformScaffold(
      body: BlocBuilder<ProfileCubit, ProfilePageState>(
        builder: (context, state) => _getBodyWidget(context, state),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, ProfilePageState state) {
    return Center(
      child: Material(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Row(
              children: [
                if (state.avatarBytes != null)
                  Container(
                      width: 100,
                      height: 100,
                      child: Image.memory(state.avatarBytes!)),
                Column(
                  children: [PlatformText(state.firstName)],
                )
              ],
            ),
            PlatformText(
              state.lastName,
            ),
            PlatformText(
              state.secondLastName,
            ),
            PlatformText(
              state.emailAdress,
            ),
            PlatformText(
              state.facultyName,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: PlatformElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).signOutUser();
                },
                child: const Text("Sign Out"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
