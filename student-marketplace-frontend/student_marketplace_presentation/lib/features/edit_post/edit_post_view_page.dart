import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/add_post/add_post_view_page.dart';

class EditPostViewPage extends StatelessWidget {
  final SalePostEntity post;

  const EditPostViewPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(
          'Edit post',
          style: TextStyle(color: Theme.of(context).splashColor),
        ),
        cupertino: (context, platform) =>
            CupertinoNavigationBarData(previousPageTitle: 'Post'),
      ),
      body: AddPostPage(
        postToEdit: post,
      ),
    );
  }
}
