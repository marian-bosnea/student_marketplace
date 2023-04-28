import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_presentation/core/constants/enums.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';

import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/own_post_list_item.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../shared/empty_list_placeholder.dart';

class OwnPostsViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  OwnPostsViewPage({super.key});

  Widget cupertinoSliverNavBar(BuildContext context) =>
      CupertinoSliverNavigationBar(
        automaticallyImplyLeading: true,
        previousPageTitle: 'Account',
        backgroundColor: Theme.of(context).highlightColor,
        largeTitle: Text(
          'My Posts',
          style: TextStyle(color: Theme.of(context).splashColor),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnPostsViewBloc, OwnPostsViewState>(
        builder: (context, state) {
      return PlatformScaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: isMaterial(context)
            ? PlatformAppBar(
                backgroundColor: Theme.of(context).highlightColor,
                automaticallyImplyLeading: true,
                cupertino: (context, platform) =>
                    CupertinoNavigationBarData(previousPageTitle: 'Account'),
              )
            : null,
        body: _getBodyWidget(context, state),
      );
    });
  }

  Widget _getBodyWidget(BuildContext context, OwnPostsViewState state) {
    if (state.status == PostsViewStatus.loading) {
      return Center(
        child: isMaterial(context)
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator(),
      );
    }
    return isMaterial(context)
        ? Material(
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) => SizedBox(
                    height: 150,
                    child:
                        OwnPostListItem(post: state.posts.elementAt(index)))),
          )
        : CustomScrollView(
            slivers: [
              cupertinoSliverNavBar(context),
              if (state.posts.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyListPlaceholder(
                    message: 'You havent post anything on marketplace',
                  ),
                ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: 100,
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      color: Theme.of(context).primaryColor,
                      child: ToggleSwitch(
                          minWidth: 100.0,
                          minHeight: 50.0,
                          cornerRadius: 20.0,
                          initialLabelIndex: 0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Theme.of(context).highlightColor,
                          inactiveFgColor: Theme.of(context).splashColor,
                          totalSwitches: 3,
                          labels: const ["Active", "Sold", "Inactive"],
                          iconSize: 30.0,
                          borderWidth: 1.0,
                          borderColor: [Theme.of(context).splashColor],
                          activeBgColors: [
                            [Theme.of(context).splashColor],
                            [Theme.of(context).splashColor],
                            [Theme.of(context).splashColor],
                          ],
                          onToggle: (index) {}),
                    ),
                  ),
                ),
              ),
              if (state.posts.isNotEmpty)
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: state.posts.length, (context, index) {
                  return SizedBox(
                      height: 150,
                      child:
                          OwnPostListItem(post: state.posts.elementAt(index)));
                }))
            ],
          );
  }
}
