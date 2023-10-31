import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../reusable/reusable_widgets.dart';

class UserEventsCreationScreen extends StatefulWidget {
  const UserEventsCreationScreen({super.key});

  @override
  State<UserEventsCreationScreen> createState() =>
      _UserEventsCreationScreenState();
}

class _UserEventsCreationScreenState extends State<UserEventsCreationScreen> {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('events');

  TextEditingController _eventTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add Event",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.blue),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                textField("Enter The Event Name", Icons.event, false,
                    _eventTextController),
                IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
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
                      // Navigation(context, ImageDemo());
                    } catch (error) {}
                  },
                  icon: Icon(Icons.camera_alt),
                ),
                reuseButton(context, "Add Event", () {
                  final userID = FirebaseAuth.instance.currentUser?.uid;
                  insertEventData(_eventTextController.text, userID!);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertEventData(String name, String UserID) {
    collectionReference.doc().set({
      'name': name,
      'userID': UserID,
    }).then((_) async {
      print('User Event Added successfully');
    }).catchError((error) {
      print('Failed to Add User Event: $error');
    });
  }
}
