import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/core/theme/theme_data.dart';
import 'package:student_marketplace_presentation/features/shared/empty_list_placeholder.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_bloc.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/own_post_list_item.dart';

class UserProfileViewPage extends StatelessWidget {
  final int userId;
  final sl = GetIt.instance;

  UserProfileViewPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileViewBloc(
          getUserUsecase: sl.call(), getAllPostsByOwnerUsecase: sl.call())
        ..fetchUserProfile(userId),
      child: BlocBuilder<UserProfileViewBloc, UserProfileViewState>(
          builder: (context, state) {
        return PlatformScaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: isMaterial(context)
              ? PlatformAppBar(
                  backgroundColor: Theme.of(context).highlightColor,
                  automaticallyImplyLeading: true,
                  cupertino: (context, platform) =>
                      CupertinoNavigationBarData(previousPageTitle: 'Posts'),
                )
              : null,
          body: CustomScrollView(slivers: [
            if (isCupertino(context))
              CupertinoSliverNavigationBar(
                previousPageTitle: 'Posts',
                backgroundColor: Theme.of(context).highlightColor,
                largeTitle: Text(
                  'Profile',
                  style: TextStyle(color: Theme.of(context).splashColor),
                ),
              ),
            _getBodyWidget(context, state),
            if (state.posts.isEmpty)
              const SliverToBoxAdapter(
                child: EmptyListPlaceholder(
                    message: 'User has not listed any item on marketplace'),
              )
          ]),
        );
      }),
    );
  }

  Widget _getBodyWidget(BuildContext context, UserProfileViewState state) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(childCount: state.posts.length + 1,
            (context, index) {
      if (index == 0) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Material(
              color: Theme.of(context).highlightColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (state.avatarBytes != null)
                      SizedBox(
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(200),
                        child: CircleAvatar(
                            foregroundImage: Image.memory(
                          state.avatarBytes!,
                        ).image),
                      ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        width: ScreenUtil().setWidth(500),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  PlatformText(
                                    '${state.firstName} ',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  PlatformText('${state.lastName} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  if (state.secondLastName != 'null')
                                    PlatformText(state.secondLastName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                ],
                              ),
                              PlatformText(state.facultyName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                            ]),
                      ),
                    )
                  ],
                ),
              )),
        );
      }

      return OwnPostListItem(post: state.posts.elementAt(index - 1));
    }));
  }
}
