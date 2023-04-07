import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_presentation/core/constants/enums.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';

import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/own_post_list_item.dart';

import '../shared/empty_list_placeholder.dart';

class OwnPostsViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  OwnPostsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OwnPostsViewBloc(getAllPostsByOwnerUsecase: sl.call())
            ..fetchOwnPosts(),
      child: BlocBuilder<OwnPostsViewBloc, OwnPostsViewState>(
          builder: (context, state) {
        return PlatformScaffold(
          appBar: isMaterial(context)
              ? PlatformAppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: true,
                  cupertino: (context, platform) =>
                      CupertinoNavigationBarData(previousPageTitle: 'Account'),
                )
              : null,
          body: _getBodyWidget(context, state),
        );
      }),
    );
  }

  Widget _getBodyWidget(BuildContext context, OwnPostsViewState state) {
    if (state.status == PostsViewStatus.loading) {
      return Center(
        child: isMaterial(context)
            ? const CircularProgressIndicator()
            : const CupertinoActivityIndicator(),
      );
    }
    if (state.posts.isEmpty) {
      return const EmptyListPlaceholder(
        message: 'You havent post anything on marketplace',
      );
    }
    return isMaterial(context)
        ? Material(
            child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) => SizedBox(
                    height: 150,
                    child:
                        OwnPostListItem(post: state.posts.elementAt(index)))),
          )
        : CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(
                automaticallyImplyLeading: true,
                previousPageTitle: 'Account',
                largeTitle: Text(
                  'My Posts',
                  style: TextStyle(color: accentColor),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: state.posts.length, (context, index) {
                return SizedBox(
                    height: 150,
                    child: OwnPostListItem(post: state.posts.elementAt(index)));
              }))
            ],
          );
  }
}
