import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_presentation/features/search/search_view_state.dart';
import 'package:student_marketplace_presentation/features/search/search_view_bloc.dart';

import '../../core/theme/colors.dart';
import '../shared/post_item.dart';

class SearchViewPage extends StatelessWidget {
  const SearchViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchViewBloc, SearchViewState>(
      builder: (context, state) {
        return Material(
          color: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: PlatformTextField(
                  cupertino: (context, target) =>
                      _searchCupertinoTextFieldData(context, state.status),
                  onChanged: (text) => BlocProvider.of<SearchViewBloc>(context)
                      .performSearch(text),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: GridView.builder(
                    itemCount: state.posts.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      final post = state.posts.elementAt(index);
                      return PostItem(
                        post: post,
                        onTap: () {
                          BlocProvider.of<SearchViewBloc>(context)
                              .goToDetailedPostPage(post.postId!, context);
                        },
                      );
                    }),
              ))
            ],
          ),
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
