import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/theme/colors.dart';
import 'package:student_marketplace_frontend/features/presentation/posts_view/widgets/post_item.dart';
import 'package:student_marketplace_frontend/features/presentation/search/search_page_state.dart';
import 'package:student_marketplace_frontend/features/presentation/search/search_view_bloc.dart';

import '../shared/animation_options.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchPageState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: 50,
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: PlatformTextField(
                cupertino: (context, target) =>
                    _searchCupertinoTextFieldData(context, state.status),
                onChanged: (text) =>
                    BlocProvider.of<SearchBloc>(context).performSearch(text),
              ),
            ),
            Expanded(
                child: Material(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: LiveGrid.options(
                    itemCount: state.posts.length,
                    controller: ScrollController(),
                    options: salePostAnimationOptions,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index, anim) {
                      final post = state.posts.elementAt(index);
                      return AnimateIfVisible(
                          key: ValueKey(post.postId),
                          duration: const Duration(milliseconds: 200),
                          builder: (context, animation) => FadeTransition(
                                opacity: Tween<double>(begin: 0, end: 1)
                                    .animate(animation),
                                child: PostItem(
                                  post: post,
                                  onTap: () {
                                    BlocProvider.of<SearchBloc>(context)
                                        .goToDetailedPostPage(
                                            post.postId!, context);
                                  },
                                ),
                              ));
                    }),
              ),
            ))
          ],
        );
      },
    );
  }

  CupertinoTextFieldData _searchCupertinoTextFieldData(
      BuildContext context, SearchPageStatus status) {
    return CupertinoTextFieldData(
      padding: const EdgeInsets.only(left: 10),
      prefix: SizedBox(
        width: 30,
        height: 30,
        child: status == SearchPageStatus.loading
            ? const CupertinoActivityIndicator()
            : const Icon(
                CupertinoIcons.search,
                color: accentColor,
              ),
      ),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
