import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../notifications/welcomeNotification.dart';
import 'notificationscreen.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              // final _firebaseMessaging = FirebaseMessaging.instance;
              // _firebaseMessaging.get
              // await  http.post(Uri.parse(uri)),
              // body
            },
            child: Text('Click')),
      ),
    );
  }
}
