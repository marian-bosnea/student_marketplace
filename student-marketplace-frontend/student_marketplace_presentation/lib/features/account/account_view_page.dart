import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_page.dart';
import '../../core/theme/colors.dart';

import '../authentication/auth_bloc.dart';
import 'account_view_bloc.dart';
import 'account_view_state.dart';

class AccountViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  AccountViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<AccountViewBloc>()..fetchUserProfile(null),
      child: BlocBuilder<AccountViewBloc, AccountViewState>(
        builder: (context, state) => _getBodyWidget(context, state),
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context, AccountViewState state) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/profile_background.png'),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                    style: const TextStyle(fontSize: 20, color: primaryColor),
                  ),
                  PlatformText('${state.lastName} ',
                      style:
                          const TextStyle(fontSize: 20, color: primaryColor)),
                  if (state.secondLastName != 'null')
                    PlatformText(state.secondLastName,
                        style:
                            const TextStyle(fontSize: 20, color: primaryColor)),
                ],
              ),
              PlatformText(state.emailAdress,
                  style: const TextStyle(fontSize: 20, color: primaryColor)),
              PlatformText(
                state.facultyName,
              ),
            ],
          ),
          Align(
            heightFactor: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SettingsList(
                shrinkWrap: true,
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
                        leading: const LeadingIcon(
                            icon: Icon(
                          Icons.sell,
                          color: Colors.white,
                        )),
                        onPressed: (context) => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => OwnPostsViewPage())),
                        title: const Text('My posts'),
                      ),
                      SettingsTile.navigation(
                        leading: const LeadingIcon(
                            color: Colors.red,
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )),
                        onPressed: (context) {
                          BlocProvider.of<HomeViewBloc>(context)
                              .goToFavorites(context);
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
                        leading: const LeadingIcon(
                            color: Colors.red,
                            icon: Icon(
                              CupertinoIcons.power,
                              color: Colors.white,
                            )),
                        onPressed: (context) =>
                            BlocProvider.of<AuthBloc>(context)
                                .signOutUser(context),
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
    );
  }
}

class LeadingIcon extends StatelessWidget {
  final Icon icon;
  final Color color;
  const LeadingIcon({super.key, required this.icon, this.color = accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: icon,
    );
  }
}
