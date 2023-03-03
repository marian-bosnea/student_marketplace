import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AddPostPage extends StatelessWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.6,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Text(
            'Sell an item on Marketplace',
            style: TextStyle(fontSize: 20),
          ),
          PlatformTextField(
            hintText: 'Title',
            cupertino: (context, platform) =>
                _personalInfoCupertinoTextDataField(context, 0, Icons.title),
          ),
          PlatformTextField(
            hintText: 'Description',
            maxLines: 5,
            cupertino: (context, platform) =>
                _personalInfoCupertinoTextDataField(
                    context, 1, Icons.description),
          ),
          PlatformTextField(
            hintText: 'Price',
            maxLines: 1,
            cupertino: (context, platform) =>
                _personalInfoCupertinoTextDataField(
                    context, 2, Icons.price_change),
          ),
          PlatformTextField(
            hintText: 'Category',
            cupertino: (context, platform) =>
                _personalInfoCupertinoTextDataField(context, 3, Icons.category),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Card(
                  elevation: 5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 100,
                      child: const Icon(Icons.add_a_photo_outlined)),
                ),
                Card(
                  elevation: 5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 100,
                      child: const Icon(Icons.add_a_photo_outlined)),
                ),
                Card(
                  elevation: 5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 100,
                      child: const Icon(Icons.add_a_photo_outlined)),
                ),
                Card(
                  elevation: 5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 100,
                      child: const Icon(Icons.add_a_photo_outlined)),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  CupertinoTextFieldData _personalInfoCupertinoTextDataField(
      BuildContext context, int index, IconData iconData) {
    return CupertinoTextFieldData(
      prefix: Container(
        margin: const EdgeInsets.only(left: 5),
        child: Icon(
          iconData,
          size: 25,
          color: Colors.black12,
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black12)),
    );
  }
}
