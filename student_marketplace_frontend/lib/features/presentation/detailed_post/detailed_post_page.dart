import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:student_marketplace_frontend/core/theme/colors.dart';
import 'package:student_marketplace_frontend/features/domain/entities/sale_post_entity.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_cubit.dart';
import 'package:student_marketplace_frontend/features/presentation/detailed_post/detailed_post_state.dart';

class DetailedPostPage extends StatelessWidget {
  final SalePostEntity post;
  const DetailedPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailedPostCubit, DetailedPostPageState>(
      builder: (context, state) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
              automaticallyImplyLeading: false,
              leading: PlatformIconButton(
                onPressed: () => Navigator.of(context).pop(),
                padding: const EdgeInsets.all(5),
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: accentColor,
                  size: 30,
                ),
              ),
              backgroundColor: Colors.white),
          body: Material(
            child: Container(
              color: secondaryColor,
              child: ListView(
                children: [
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: post.images.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () =>
                                  BlocProvider.of<DetailedPostCubit>(context)
                                      .setSelectedImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: index == state.selectedImageIndex!
                                        ? Border.all(color: accentColor)
                                        : null,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                width: 80,
                                height: 70,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                padding: const EdgeInsets.all(5),
                                child: Center(
                                    child: Image.memory(
                                  post.images[index],
                                  width: 40,
                                  height: 40,
                                )),
                              ),
                            );
                          }),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.memory(
                      post.images[state.selectedImageIndex!],
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          post.categoryName!,
                                          style: const TextStyle(
                                              color: accentColor),
                                        ),
                                        Text(
                                          post.title,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${post.price} RON',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: PlatformIconButton(
                                    onPressed: () {},
                                    padding: const EdgeInsets.all(5),
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        const Divider(
                          height: 0.1,
                          color: Colors.black26,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.feed,
                                        color: accentColor,
                                      ),
                                      Text(
                                        'Description',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  post.description!,
                                  textAlign: TextAlign.start,
                                )
                              ]),
                        ),
                        const Divider(
                          height: 0.1,
                          color: Colors.black26,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.info_outline,
                                        color: accentColor,
                                      ),
                                      Text(
                                        'About',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Sold by ',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text(
                                      post.ownerName!,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Posted on  ',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text(
                                      post.postingDate!,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Views: ',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text(
                                      post.viewsCount!.toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                        const Divider(
                          height: 0.1,
                          color: Colors.black26,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.insert_chart,
                                        color: accentColor,
                                      ),
                                      Text(
                                        'Statistics',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Views: ',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    Text(
                                      post.viewsCount!.toString(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
