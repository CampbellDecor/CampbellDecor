import 'dart:convert';

import 'package:campbelldecor/screens/notifications/notification_services.dart';
import 'package:campbelldecor/screens/notifications/welcomeNotification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../reusable/reusable_methods.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              sendNotificationForAdmin(
                  '2pYvBFGBeLNBGgsNagqR',
                  'Booking request',
                  'Your booking request has been received. We will notify you shortly with our response.');
            },
            child: Text('SendNotification')),
      ),
    );
  }
}
