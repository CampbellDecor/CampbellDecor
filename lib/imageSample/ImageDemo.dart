import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageDemo extends StatefulWidget {
  const ImageDemo({super.key});

  @override
  State<ImageDemo> createState() => _ImageDemoState();
}

final storageRef = FirebaseStorage.instance.ref();

class _ImageDemoState extends State<ImageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image show'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  show();
                },
                child: Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}

Future<void> show() async {
  final islandRef = storageRef.child("Images/img.png");
  try {
    const oneMegabyte = 1024 * 1024;
    final Uint8List? data = await islandRef.getData(oneMegabyte);
// Data for "images/island.jpg" is returned, use this as needed.
  } on FirebaseException catch (e) {
// Handle any errors.
  }
}
