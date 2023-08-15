import 'dart:io';
import 'package:campbelldecor/imageSample/ImageDemo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../reusable/reusable_methods.dart';

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
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  // print('file path is : ${file?.path}');
                  String? imageUrl;
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  // if (file == null) return;
                  final storageRef = FirebaseStorage.instance.ref();
                  Reference? imagesRef = storageRef.child('Images');
                  final fileName = imagesRef.child(uniqueFileName);

                  try {
                    final uploadTask = fileName.putFile(File(file!.path));
                    uploadTask.snapshotEvents
                        .listen((TaskSnapshot taskSnapshot) {
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          final progress = 100.0 *
                              (taskSnapshot.bytesTransferred /
                                  taskSnapshot.totalBytes);
                          print("Upload is $progress% complete.");
                          break;
                        case TaskState.paused:
                          print("Upload is paused.");
                          break;
                        case TaskState.canceled:
                          print("Upload was canceled");
                          break;
                        case TaskState.error:
                          // Handle unsuccessful uploads
                          break;
                        case TaskState.success:
                          // Handle successful uploads on complete

                          break;
                      }
                    });

                    imageUrl = await fileName.getDownloadURL();
                    Navigation(context, ImageDemo());
                  } catch (error) {}
                },
                icon: Icon(Icons.camera_alt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
