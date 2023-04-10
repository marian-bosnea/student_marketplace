import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_bloc.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/own_post_list_item.dart';

class UserProfileViewPage extends StatelessWidget {
  final int userId;
  final sl = GetIt.instance;

  UserProfileViewPage({super.key, required this.userId});

  final nameTextStyle = TextStyle(
      fontSize: ScreenUtil().setSp(40),
      color: Colors.black,
      fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileViewBloc(
          getUserUsecase: sl.call(), getAllPostsByOwnerUsecase: sl.call())
        ..fetchUserProfile(userId),
      child: BlocBuilder<UserProfileViewBloc, UserProfileViewState>(
          builder: (context, state) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            cupertino: (context, platform) =>
                CupertinoNavigationBarData(previousPageTitle: 'Posts'),
          ),
          body: CustomScrollView(slivers: [
            //if (isCupertino(context)) CupertinoSliverNavigationBar(),
            _getBodyWidget(context, state)
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
        return Material(
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
              Container(
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
                            style: nameTextStyle,
                          ),
                          PlatformText('${state.lastName} ',
                              style: nameTextStyle),
                          if (state.secondLastName != 'null')
                            PlatformText(state.secondLastName,
                                style: nameTextStyle),
                        ],
                      ),
                      PlatformText(state.facultyName,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.black45)),
                      PlatformText(state.emailAdress,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              color: Colors.white)),
                    ]),
              )
            ],
          ),
        ));
      }

      return OwnPostListItem(post: state.posts.elementAt(index - 1));
    }));
  }
}
