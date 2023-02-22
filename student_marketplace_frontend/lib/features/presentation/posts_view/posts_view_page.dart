import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/presentation/posts_view/post_view_state.dart';
import 'package:student_marketplace_frontend/features/presentation/posts_view/posts_view.cubit.dart';

class PostViewPage extends StatelessWidget {
  const PostViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostViewCubit>(context).fetchAllPosts();
    return BlocBuilder<PostViewCubit, PostViewState>(
      builder: (context, state) {
        if (state.status == PostsViewStatus.fail) {
          return const Center(
            child: Text(
              "Failed to load posts...",
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (contex, index) {
              print(state.posts.length);
              return Container(
                child: Text(state.posts.elementAt(index).title),
              );
            });
      },
    );
  }
}
