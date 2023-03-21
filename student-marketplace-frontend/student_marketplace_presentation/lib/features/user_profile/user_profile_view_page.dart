import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_bloc.dart';
import 'package:student_marketplace_presentation/features/user_profile/user_profile_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/own_post_list_item.dart';

import '../../core/theme/colors.dart';

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
          child: Container(
            color: primaryColor,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: accentColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.avatarBytes != null)
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                                foregroundImage:
                                    Image.memory(state.avatarBytes!).image),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlatformText(
                          '${state.firstName} ',
                          style: const TextStyle(
                              fontSize: 20, color: primaryColor),
                        ),
                        PlatformText('${state.lastName} ',
                            style: const TextStyle(
                                fontSize: 20, color: primaryColor)),
                        if (state.secondLastName != 'null')
                          PlatformText(state.secondLastName,
                              style: const TextStyle(
                                  fontSize: 20, color: primaryColor)),
                      ],
                    ),
                    PlatformText(state.emailAdress,
                        style:
                            const TextStyle(fontSize: 20, color: primaryColor)),
                    PlatformText(
                      state.facultyName,
                      style: const TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        );
      }

      return OwnPostListItem(post: state.posts.elementAt(index - 1));
    }));
  }
}
