import 'package:flutter/material.dart';
import '../notifications/welcomeNotification.dart';
import 'notificationscreen.dart';

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
            onPressed: () {
              NotificationService notificationService = NotificationService();
              notificationService.showNotification(
                  title: 'Create Account', body: 'Welcome to My App');
            },
            child: Text('Click')),
      ),
    );
  }
}
