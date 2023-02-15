import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'presentation/pages/authentication_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlatformApp(
      title: 'Student Marketplace',
      debugShowCheckedModeBanner: false,
      home: AuthenticationPage(),
    );
  }
}
