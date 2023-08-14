import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImagePage extends StatefulWidget {
  @override
  _FirebaseImagePageState createState() => _FirebaseImagePageState();
}

class _FirebaseImagePageState extends State<FirebaseImagePage> {
  String imageURL = '';

  // Function to retrieve the image URL from Firebase Storage
  Future<void> getImageURL() async {
    // String path = 'Images/img.png';
    try {
      final ref =
          FirebaseStorage.instance.ref().child('Services/photography.jpeg');
      final url = await ref.getDownloadURL();
      setState(() {
        imageURL = url;
        print('Image URL is $imageURL');
      });
    } catch (e) {
      print('Error getting image URL: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getImageURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Image'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 500,
              child: imageURL.isNotEmpty
                  ? Image.network(
                      imageURL,
                      fit: BoxFit.cover,
                    ) // Display the image using the URL
                  : CircularProgressIndicator(), // Show a loading indicator if imageURL is empty
            ),
          ],
        ),
      ),
    );
  }
}
