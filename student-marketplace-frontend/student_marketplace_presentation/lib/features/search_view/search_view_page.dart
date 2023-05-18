import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/category_item.dart';

import '../posts_view/posts_view_bloc.dart';

class SearchViewPage extends StatelessWidget {
  const SearchViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postsViewBloc = BlocProvider.of<PostViewBloc>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Material(
                  elevation: 5,
                  color: Theme.of(context).highlightColor,
                  type: MaterialType.card,
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(25)),
                    height: 70,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      children: [
                        Hero(
                          tag: 'search',
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 110,
                            height: 50,
                            child: PlatformTextField(
                              hintText: 'What are you looking for today?',
                              cupertino: (context, platform) =>
                                  CupertinoTextFieldData(
                                placeholderStyle:
                                    Theme.of(context).textTheme.displayMedium,
                                prefix: SizedBox(
                                  width: 50,
                                  child: Icon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    color: Theme.of(context).splashColor,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).splashColor)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PlatformTextButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color!),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Material(
                    elevation: 1,
                    type: MaterialType.card,
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(25),
                    child: Hero(
                      tag: 'categories',
                      child: Container(
                        //margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor,
                            borderRadius: BorderRadius.circular(25)),
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                            children: List.generate(
                                postsViewBloc.state.categories.length, (index) {
                          final category =
                              postsViewBloc.state.categories.elementAt(index);

                          return FittedBox(
                            child: SizedBox(
                              height: 70,
                              child: CategoryItem(
                                label: category.name,
                                isSelected: false,
                                onTap: () {},
                              ),
                            ),
                          );
                        })),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
