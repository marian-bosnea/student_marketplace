import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/theme/colors.dart';
import 'favorites_view_bloc.dart';
import 'favorites_view_state.dart';
import 'widgets/list_post_item.dart';

class FavoritesViewPage extends StatelessWidget {
  const FavoritesViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FavoritesViewBloc>(context).getFavoritePosts();
    return BlocBuilder<FavoritesViewBloc, FavoritesViewState>(
      builder: (context, state) {
        return Container(
          color: primaryColor,
          child: ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    key: ValueKey(post.postId),
                    startActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) =>
                            BlocProvider.of<FavoritesViewBloc>(context)
                                .removeFromFavorites(context, post.postId!),
                        autoClose: true,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: CupertinoIcons.trash,
                        label: 'Remove',
                      ),
                    ]),
                    child: ListPostItem(
                        post: post,
                        onTap: () => BlocProvider.of<FavoritesViewBloc>(context)
                            .goToDetailedPostPage(post, context)),
                  ),
                );
              }),
        );
      },
    );
  }
}
