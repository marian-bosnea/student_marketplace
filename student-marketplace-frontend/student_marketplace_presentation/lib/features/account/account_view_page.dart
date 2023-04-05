import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import '../../core/theme/colors.dart';

import 'account_view_bloc.dart';
import 'account_view_state.dart';

class AccountViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  AccountViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountViewBloc, AccountViewState>(
      builder: (context, state) => _getBodyWidget(context, state),
    );
  }

  Widget _getBodyWidget(BuildContext context, AccountViewState state) {
    return Material(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: accentColor,
          child: Column(
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
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(50), color: Colors.white),
                  ),
                  PlatformText('${state.lastName} ',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(50),
                          color: Colors.white)),
                  if (state.secondLastName != 'null')
                    PlatformText(state.secondLastName,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(50),
                            color: Colors.white)),
                ],
              ),
              PlatformText(state.emailAdress,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(50), color: Colors.white)),
              PlatformText(state.facultyName,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(50), color: Colors.white)),
            ],
          ),
        ),
        Column(children: [
          ProfileMenuItem(
            icon: const Icon(
              Icons.price_change,
              color: Colors.white,
            ),
            color: accentColor,
            label: 'My Posts',
            onTap: () => Navigator.of(context).pushNamed('/own_posts'),
          ),
          ProfileMenuItem(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            color: Colors.red,
            label: 'Favorites',
            onTap: () => BlocProvider.of<HomeViewBloc>(context).goToFavorites(),
          ),
          ProfileMenuItem(
            icon: const Icon(
              CupertinoIcons.power,
              color: Colors.white,
            ),
            color: Colors.red,
            label: 'Logout',
            onTap: () =>
                BlocProvider.of<AccountViewBloc>(context).logout(context),
          )
        ])
      ]),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final Icon icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const ProfileMenuItem(
      {super.key,
      required this.icon,
      required this.color,
      required this.label,
      required this.onTap,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: icon,
                      ),
                      Text(
                        label,
                        style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                      ),
                    ],
                  ),
                  const Icon(CupertinoIcons.arrow_right)
                ],
              ),
            ),
            if (!isLast)
              const Divider(
                indent: 50,
                thickness: 1,
              )
          ],
        ),
      ),
    );
  }
}
