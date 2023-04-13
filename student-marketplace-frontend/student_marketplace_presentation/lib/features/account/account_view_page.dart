import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import 'package:student_marketplace_presentation/features/home/home_view_bloc.dart';
import 'package:student_marketplace_presentation/features/shared/list_action_item.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setHeight(200),
                        child: CircleAvatar(
                            foregroundImage: Image.memory(
                          state.avatarBytes!,
                        ).image),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: ScreenUtil().setWidth(450),
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
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: primaryColor),
              child: Column(
                children: [
                  ListActionItem(
                    icon: const Icon(
                      FontAwesomeIcons.box,
                      color: Colors.white,
                    ),
                    color: Colors.blue,
                    label: 'Orders',
                    hasTrailing: true,
                    onTap: () =>
                        Navigator.of(context).pushNamed(PageNames.ordersView),
                  ),
                  ListActionItem(
                    icon: const Icon(
                      FontAwesomeIcons.mapPin,
                      color: Colors.white,
                    ),
                    color: Colors.orange,
                    label: 'Adresses',
                    hasTrailing: true,
                    onTap: () =>
                        Navigator.of(context).pushNamed(PageNames.addressView),
                  ),
                  ListActionItem(
                    icon: const Icon(
                      FontAwesomeIcons.tags,
                      color: Colors.white,
                    ),
                    color: accentColor,
                    label: 'Posts',
                    hasTrailing: true,
                    onTap: () => Navigator.of(context).pushNamed('/own_posts'),
                  ),
                  ListActionItem(
                    isLast: true,
                    icon: const Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    hasTrailing: true,
                    label: 'Favorites',
                    onTap: () =>
                        BlocProvider.of<HomeViewBloc>(context).goToFavorites(),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                'My Account',
                style: TextStyle(color: Colors.black45),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: primaryColor),
              child: Column(children: [
                ListActionItem(
                  isLast: true,
                  icon: const Icon(
                    FontAwesomeIcons.rightFromBracket,
                    color: Colors.white,
                  ),
                  color: Colors.red,
                  hasTrailing: false,
                  label: 'Sign Out',
                  onTap: () =>
                      BlocProvider.of<AccountViewBloc>(context).logout(context),
                ),
              ]),
            )
          ])
        ]),
      ),
    );
  }
}
