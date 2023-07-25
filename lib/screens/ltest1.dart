import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter the name of Image'),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');
                    String imageUrl = '';
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    // if (file == null) return;
                    Reference fileref = FirebaseStorage.instance.ref();
                    final img = fileref.child('Images');
                    final imgName = img.child(uniqueFileName);

                    try {
                      await imgName.putFile(File(file!.path));
                      imageUrl = await imgName.getDownloadURL();
                    } catch (error) {}
                  },
                  icon: Icon(Icons.camera_alt)),
            ],
          ),
        ),
      ),
    );
  }
}
