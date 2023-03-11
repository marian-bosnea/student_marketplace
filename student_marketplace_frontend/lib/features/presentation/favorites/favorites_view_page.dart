import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/features/presentation/favorites/favorites_view_bloc.dart';
import 'package:student_marketplace_frontend/features/presentation/favorites/favorites_view_state.dart';
import 'package:student_marketplace_frontend/features/presentation/favorites/widgets/list_post_item.dart';

class FavoritesViewPage extends StatelessWidget {
  const FavoritesViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FavoritesViewBloc>(context).getFavoritePosts();
    return BlocBuilder<FavoritesViewBloc, FavoritesViewState>(
      builder: (context, state) {
        return Material(
          color: Colors.white,
          child: ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts.elementAt(index);
                return ListPostItem(
                    post: post,
                    onTap: () => BlocProvider.of<FavoritesViewBloc>(context)
                        .goToDetailedPostPage(post, context));
              }),
        );
      },
    );
  }
}
