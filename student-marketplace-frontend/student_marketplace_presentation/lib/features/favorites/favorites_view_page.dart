import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';

import 'favorites_view_bloc.dart';
import 'favorites_view_state.dart';
import '../shared/favorite_list_item.dart';

class FavoritesViewPage extends StatelessWidget {
  final sl = GetIt.instance;

  FavoritesViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesViewBloc, FavoritesViewState>(
      builder: (context, state) {
        if (state.posts.isEmpty) {
          return getEmptyListPlaceholder(state);
        }
        return getLoadedItemsList(context, state);
      },
    );
  }

  Widget getEmptyListPlaceholder(FavoritesViewState state) {
    return const EmptyListPlaceholder(
      message: 'You dont have any item added to favorites',
    );
  }

  Widget getLoadedItemsList(BuildContext context, FavoritesViewState state) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            final post = state.posts.elementAt(index);
            return Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Slidable(
                  key: ValueKey(post.postId),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) =>
                          BlocProvider.of<FavoritesViewBloc>(context)
                              .removeFromFavorites(context, post.postId!),
                      autoClose: true,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: FontAwesomeIcons.trash,
                      label: 'Remove',
                    ),
                  ]),
                  child: FavoriteListItem(
                    post: post,
                  )),
            );
          }),
    );
  }
}
