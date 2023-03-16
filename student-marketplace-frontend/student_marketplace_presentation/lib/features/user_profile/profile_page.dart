import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:student_marketplace_presentation/features/home/home_page_bloc.dart';
import '../../core/theme/colors.dart';
import 'profile_page_state.dart';

import '../authentication/auth_cubit.dart';
import 'profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
    return PlatformScaffold(
      body: isCupertino(context)
          ? NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScroller) {
                return <Widget>[
                  const CupertinoSliverNavigationBar(
                    previousPageTitle: 'Home',
                    largeTitle: Text(
                      'Profile',
                      style: TextStyle(color: accentColor),
                    ),
                  )
                ];
              },
              body: _getBodyWidet(context, state))
          : _getBodyWidet(context, state),
    );
  }

  Widget _getBodyWidet(BuildContext context, ProfilePageState state) {
    return Center(
      child: Material(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.avatarBytes != null)
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                        foregroundImage:
                            Image.memory(state.avatarBytes!).image),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformText(
                  '${state.firstName} ',
                  style: const TextStyle(fontSize: 20),
                ),
                PlatformText('${state.lastName} ',
                    style: const TextStyle(fontSize: 20)),
                if (state.secondLastName != 'null')
                  PlatformText(state.secondLastName,
                      style: const TextStyle(fontSize: 20)),
              ],
            ),
            PlatformText(state.emailAdress,
                style: const TextStyle(fontSize: 20)),
            PlatformText(
              state.facultyName,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: SettingsList(
                  physics: const NeverScrollableScrollPhysics(),
                  contentPadding: EdgeInsets.zero,
                  lightTheme: const SettingsThemeData(
                      settingsListBackground: Colors.white),
                  sections: [
                    SettingsSection(
                      margin: EdgeInsetsDirectional.zero,
                      title: const Text('Posts'),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: const Icon(
                            Icons.ballot,
                            color: accentColor,
                          ),
                          onPressed: (context) {},
                          title: const Text('My posts'),
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: (context) {
                            BlocProvider.of<HomePageBloc>(context)
                                .goToFavorites();
                            Navigator.of(context).pop();
                          },
                          title: const Text('Favorites'),
                        ),
                      ],
                    ),
                    SettingsSection(
                      margin: EdgeInsetsDirectional.zero,
                      title: const Text('Account'),
                      tiles: <SettingsTile>[
                        SettingsTile.navigation(
                          leading: const Icon(
                            CupertinoIcons.power,
                            color: Colors.red,
                          ),
                          onPressed: (context) =>
                              BlocProvider.of<AuthCubit>(context).signOutUser(),
                          title: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
