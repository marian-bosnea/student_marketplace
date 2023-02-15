import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../http_interface.dart';

import '../models/user_profile.dart';

class UserProfilePage extends StatefulWidget {
  final HttpInterface httpInterface;

  const UserProfilePage({super.key, required this.httpInterface});
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: const Text("User profile"),
          trailingActions: [
            PlatformIconButton(
                icon: Icon(
              isCupertino(context) ? CupertinoIcons.pencil : Icons.edit,
              color: Colors.black,
            ))
          ],
        ),
        body: FutureBuilder<UserProfile?>(
          future: widget.httpInterface.fetchUserProfile(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 100,
                          height: 200,
                          child: Image.network(
                              "https://www.w3schools.com/howto/img_avatar.png")),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data!.firstName} ${snapshot.data!.lastName} ${snapshot.data!.secondaryLastName ?? " "}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              const Text(
                                "Student",
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )
                            ]),
                      )
                    ],
                  )
                ],
              );
            }
          },
        ));
  }
}
