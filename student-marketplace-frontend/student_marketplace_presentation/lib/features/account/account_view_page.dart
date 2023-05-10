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
import '../../core/theme/theme_data.dart';

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
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
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
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  PlatformText('${state.lastName} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge),
                                  if (state.secondLastName != 'null')
                                    PlatformText(state.secondLastName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                ],
                              ),
                              PlatformText(state.facultyName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
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
              child: Text(
                'Dashboard',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).highlightColor),
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
                        Navigator.of(context).pushNamed(RouteNames.ordersView),
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
                        Navigator.of(context).pushNamed(RouteNames.addressView),
                  ),
                  ListActionItem(
                    icon: const Icon(
                      FontAwesomeIcons.tags,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).splashColor,
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
              child: Text(
                'My Account',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).highlightColor),
              child: Column(children: [
                ListActionItem(
                  isLast: false,
                  icon: const Icon(
                    FontAwesomeIcons.gear,
                    color: Colors.white,
                  ),
                  color: Colors.grey,
                  hasTrailing: true,
                  label: 'Settings',
                  onTap: () =>
                      Navigator.of(context).pushNamed(RouteNames.settings),
                ),
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
