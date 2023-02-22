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
      body: BlocConsumer<ProfileCubit, ProfilePageState>(
        listener: (context, state) {},
        builder: (context, state) => _getBodyWidget(context, state),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, ProfilePageState state) {
    return Center(
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
                      "Profile",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  PlatformText(
                    state.firstName,
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
      ),
    );
  }
}
