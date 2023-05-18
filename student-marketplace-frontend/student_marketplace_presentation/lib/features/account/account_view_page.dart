import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import 'package:student_marketplace_presentation/features/shared/list_action_item.dart';

import 'account_view_bloc.dart';
import 'account_view_state.dart';

class AccountViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  final shadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ];

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
          AccountPanel(
            state: state,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PanelTitle(
              title: 'Dashboard',
            ),
            const DashboardActionsPanel(),
            const PanelTitle(
              title: 'Account',
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: _getPanelDecoration(context),
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

  BoxDecoration _getPanelDecoration(BuildContext context) {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).highlightColor);
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  const PanelTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

class DashboardActionsPanel extends StatelessWidget {
  const DashboardActionsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).highlightColor),
      // child: GridView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      //       maxCrossAxisExtent: 200,
      //       childAspectRatio: 2 / 2,
      //       crossAxisSpacing: 10,
      //       mainAxisSpacing: 10),
      //   children: [
      //     DashboardItem(
      //       assetPath: 'assets/illustrations/box.png',
      //       label: 'Orders',
      //       color: [Colors.blue.withAlpha(200), Colors.indigo.withAlpha(200)],
      //       onTap: () => Navigator.of(context).pushNamed(RouteNames.ordersView),
      //     ),
      //     DashboardItem(
      //       assetPath: 'assets/illustrations/address.png',
      //       label: 'My Addresses',
      //       color: [Colors.orangeAccent.withAlpha(200), Colors.orange],
      //       onTap: () =>
      //           Navigator.of(context).pushNamed(RouteNames.addressView),
      //     ),
      //     DashboardItem(
      //         assetPath: 'assets/illustrations/post.png',
      //         label: 'Listings',
      //         color: [
      //           Colors.deepOrangeAccent.withAlpha(150),
      //           Colors.orange.withAlpha(200),
      //         ],
      //         onTap: () => Navigator.of(context).pushNamed('/own_posts'))
      //   ],
      // ),
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
            onTap: () => Navigator.of(context).pushNamed(RouteNames.ordersView),
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
            isLast: true,
            onTap: () =>
                Navigator.of(context).pushNamed(RouteNames.ownPostsView),
          ),
        ],
      ),
    );
  }
}

class AccountPanel extends StatelessWidget {
  final AccountViewState state;
  const AccountPanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(100),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state.avatarBytes != null)
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
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            PlatformText('${state.lastName} ',
                                style: Theme.of(context).textTheme.labelLarge),
                            if (state.secondLastName != 'null')
                              PlatformText(state.secondLastName,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                        PlatformText(state.facultyName,
                            style: Theme.of(context).textTheme.displayMedium),
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
    );
  }
}

class DashboardItem extends StatefulWidget {
  final VoidCallback onTap;
  final String assetPath;
  final String label;
  final List<Color> color;
  const DashboardItem(
      {super.key,
      required this.onTap,
      required this.assetPath,
      required this.label,
      required this.color});

  @override
  State<DashboardItem> createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animationTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 30),
      vsync: this,
    );
    _animationTween =
        Tween(begin: 20.0, end: 0.0).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.forward();
        widget.onTap();
      },
      onTapDown: (details) {
        _animationController.forward();
      },
      onTapUp: (details) {
        _animationController.reverse();
      },
      child: Material(
        elevation: _animationTween.value,
        borderRadius: BorderRadius.circular(25),
        type: MaterialType.card,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.color.first,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.color,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(100),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Image.asset(widget.assetPath),
              Text(
                widget.label,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
