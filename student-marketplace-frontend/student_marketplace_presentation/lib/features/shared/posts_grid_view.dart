import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';
import 'package:student_marketplace_presentation/features/shared/post_item.dart';

class PostsGridView extends StatelessWidget {
  const PostsGridView({
    super.key,
    required PagingController<int, SalePostEntity> pagingController,
  }) : _pagingController = pagingController;

  final PagingController<int, SalePostEntity> _pagingController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      sliver: PagedSliverGrid<int, SalePostEntity>(
        key: const PageStorageKey(2),
        pagingController: _pagingController,
        showNoMoreItemsIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        builderDelegate: PagedChildBuilderDelegate(
          //animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 500),
          noItemsFoundIndicatorBuilder: (context) {
            return const EmptyListPlaceholder(
                message: "Oops! There is no item here");
          },
          noMoreItemsIndicatorBuilder: (context) {
            return const Center(child: Text('No more posts'));
          },
          newPageProgressIndicatorBuilder: (context) {
            return isMaterial(context)
                ? const CircularProgressIndicator()
                : const CupertinoActivityIndicator();
          },
          itemBuilder: (context, post, index) {
            return PostItem(
              post: post,
            );
          },
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
      ),
    );
  }
}
