import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import '../../core/theme/colors.dart';

import 'account_view_bloc.dart';
import 'account_view_state.dart';

class AccountViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  final nameTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(40),
      color: Colors.black,
      fontWeight: FontWeight.w600);

  AccountViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountViewBloc, AccountViewState>(
      builder: (context, state) => _getBodyWidget(context, state),
    );
  }

  Widget _getBodyWidget(BuildContext context, AccountViewState state) {
    return Material(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setHeight(200),
                      child: CircleAvatar(
                          foregroundImage: Image.memory(
                        state.avatarBytes!,
                      ).image),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      width: ScreenUtil().setWidth(500),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                PlatformText(
                                  '${state.firstName} ',
                                  style: nameTextStyle,
                                ),
                                PlatformText('${state.lastName} ',
                                    style: nameTextStyle),
                                if (state.secondLastName != 'null')
                                  PlatformText(state.secondLastName,
                                      style: nameTextStyle),
                              ],
                            ),
                            PlatformText(state.facultyName,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(30),
                                    color: Colors.black45)),
                            PlatformText(state.emailAdress,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(50),
                                    color: Colors.white)),
                          ]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(left: 25),
            child: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.black45),
            ),
          ),
          ProfileMenuItem(
            icon: const Icon(
              Icons.local_shipping,
              color: Colors.white,
            ),
            color: accentColor,
            label: 'My Orders',
            hasTrailing: true,
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: const Icon(
              Icons.home_work,
              color: Colors.white,
            ),
            color: accentColor,
            label: 'My Adresses',
            hasTrailing: true,
            onTap: () => Navigator.of(context).pushNamed(PageNames.addressView),
          ),
          ProfileMenuItem(
            icon: const Icon(
              Icons.ballot,
              color: Colors.white,
            ),
            color: accentColor,
            label: 'My Posts',
            hasTrailing: true,
            onTap: () => Navigator.of(context).pushNamed('/own_posts'),
          ),
          ProfileMenuItem(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            color: Colors.red,
            hasTrailing: true,
            label: 'Favorites',
            onTap: () => BlocProvider.of<HomeViewBloc>(context).goToFavorites(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(left: 25),
            child: const Text(
              'My Account',
              style: TextStyle(color: Colors.black45),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 25),
            //width: ScreenUtil().setWidth(200),
            child: PlatformTextButton(
              padding: EdgeInsets.zero,
              child: const Text(
                'Sign Out',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
              ),
              onPressed: () =>
                  BlocProvider.of<AccountViewBloc>(context).logout(context),
            ),
          ),
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
  final bool hasTrailing;

  const ProfileMenuItem(
      {super.key,
      required this.icon,
      required this.color,
      required this.label,
      required this.onTap,
      this.hasTrailing = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: icon,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                if (hasTrailing)
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black45,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
