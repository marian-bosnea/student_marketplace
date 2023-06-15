import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:student_marketplace_business_logic/domain/entities/product_category_entity.dart';
import 'package:student_marketplace_business_logic/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_presentation/features/posts_view/widgets/category_item.dart';
import 'package:student_marketplace_presentation/features/search_view/search_view_bloc.dart';
import 'package:student_marketplace_presentation/features/search_view/search_view_state.dart';
import 'package:student_marketplace_presentation/features/shared/posts_grid_view.dart';

import '../../core/config/injection_container.dart';
import '../posts_view/posts_view_bloc.dart';

class SearchViewPage extends StatefulWidget {
  const SearchViewPage({super.key});

  @override
  State<SearchViewPage> createState() => _SearchViewPageState();
}

class _SearchViewPageState extends State<SearchViewPage> {
  late PagingController<int, SalePostEntity> _pagingController;
  late SearchViewBloc _pageBloc;

  @override
  void initState() {
    super.initState();

    _pagingController =
        PagingController(firstPageKey: 0, invisibleItemsThreshold: 1);
    _pageBloc = sl.call();

    _pagingController.addPageRequestListener((pageKey) async {
      await _pageBloc.fetchPostsPage(pageKey, _pagingController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsViewBloc = BlocProvider.of<PostViewBloc>(context);
    return BlocBuilder<SearchViewBloc, SearchViewState>(
      bloc: BlocProvider.of<SearchViewBloc>(context),
      builder: (context, state) {
        final bloc = BlocProvider.of<SearchViewBloc>(context);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SearchBar(
                    onSubmit: (text) {
                      bloc.setSearchQuery(text.trim());
                      _pagingController.refresh();
                    },
                  ),
                  CategoriesPanel(
                    pagingController: _pagingController,
                  ),
                  if (state.status != SearchViewStatus.intial)
                    PostsGridView(pagingController: _pagingController)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final SearchViewBloc bloc = sl<SearchViewBloc>();
  final Function(String) onSubmit;

  SearchBar({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          height: 50,
          width: MediaQuery.of(context).size.width - 20,
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: PlatformIconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      bloc.reset();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
              ),
              Hero(
                tag: 'search',
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  height: 50,
                  child: Material(
                    type: MaterialType.transparency,
                    child: PlatformTextField(
                      hintText: 'Search on marketplace',
                      onChanged: onSubmit,
                      cupertino: (context, platform) => CupertinoTextFieldData(
                        prefix: SizedBox(
                          width: 50,
                          child: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.outline)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesPanel extends StatelessWidget {
  final PagingController<int, SalePostEntity> pagingController;
  late ProductCategoryEntity? selectedCategory;

  CategoriesPanel({super.key, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchViewBloc, SearchViewState>(
      bloc: BlocProvider.of<SearchViewBloc>(context),
      builder: (context, state) {
        final bloc = BlocProvider.of<PostViewBloc>(context);
        final isACategorySelected = state.selectedCategoryId != -1;
        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width:
                isACategorySelected ? 200 : MediaQuery.of(context).size.width,
            child: Material(
              borderRadius: BorderRadius.circular(25),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: isACategorySelected ? 70 : 210,
                child: Wrap(
                    children: isACategorySelected
                        ? [
                            Builder(
                                builder: (context) =>
                                    selectedCategoryBuilder(context, state))
                          ]
                        : List.generate(bloc.state.categories.length, (index) {
                            final category =
                                bloc.state.categories.elementAt(index);

                            return FittedBox(
                              child: Hero(
                                tag: category.name,
                                child: SizedBox(
                                  height: 70,
                                  child: CategoryItem(
                                      label: category.name,
                                      isSelected: category.id ==
                                          state.selectedCategoryId,
                                      onTap: () => onTap(context, category.id)),
                                ),
                              ),
                            );
                          })),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget selectedCategoryBuilder(BuildContext context, SearchViewState state) {
    final categories = BlocProvider.of<PostViewBloc>(context).state.categories;
    final category = categories.firstWhere(
      (element) {
        return element.id == state.selectedCategoryId;
      },
    );
    return Hero(
      tag: category.name,
      child: Row(
        children: [
          SizedBox(
            height: 70,
            child: CategoryItem(
                label: category.name,
                isSelected: category.id == state.selectedCategoryId,
                onTap: () => onTap(context, category.id)),
          ),
          PlatformIconButton(
            icon: Icon(
              FontAwesomeIcons.xmark,
              color: Theme.of(context).textTheme.labelMedium!.color!,
            ),
            onPressed: () => onTap(context, category.id),
          )
        ],
      ),
    );
  }

  onTap(BuildContext context, int id) {
    BlocProvider.of<SearchViewBloc>(context).setCategoryId(id);

    pagingController.refresh();
  }
}
