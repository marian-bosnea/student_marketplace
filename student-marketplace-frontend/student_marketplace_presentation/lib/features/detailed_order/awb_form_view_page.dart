import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
                color: Theme.of(context).splashColor,
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
