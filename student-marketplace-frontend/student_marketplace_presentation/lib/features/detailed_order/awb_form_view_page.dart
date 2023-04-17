import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_marketplace_presentation/core/theme/colors.dart';

class AwbFormViewPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AwbFormViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Colors.white,
        cupertino: (context, platform) =>
            CupertinoNavigationBarData(previousPageTitle: 'Order'),
      ),
      body: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlatformTextField(
                hintText: 'AWB',
                controller: _controller,
              ),
              PlatformElevatedButton(
                color: accentColor,
                onPressed: () => Navigator.of(context).pop(_controller.text),
                child: const Text('Done'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
