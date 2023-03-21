import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_bloc.dart';
import 'package:student_marketplace_presentation/features/own_posts/own_posts_view_state.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/own_post_list_item.dart';

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
          appBar: PlatformAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            cupertino: (context, platform) =>
                CupertinoNavigationBarData(previousPageTitle: 'Posts'),
          ),
          body: _getBodyWidget(context, state),
        );
      }),
    );
  }

  Widget _getBodyWidget(BuildContext context, OwnPostsViewState state) {
    return Material(
      child: ListView.builder(
          itemCount: state.posts.length,
          itemBuilder: (context, index) => SizedBox(
              child: SizedBox(
                  height: 150,
                  child: OwnPostListItem(post: state.posts.elementAt(index))))),
    );
  }
}
