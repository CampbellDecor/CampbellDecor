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
              sendNotification('1r2DkrsQw1OsaMqw8BU8');
            },
            child: Text('SendNotification')),
      ),
    );
  }
  //
  // void sendNotification(String id) {
  //   final NotificationServices notificationServices = NotificationServices();
  //   notificationServices.getDeviceToken().then((value) async {
  //     var data = {
  //       'to':
  //           'cvrV5c-5RtqsP7FPHCVzPT:APA91bGTcrOBac4dY3cUuDuC1nz83674veRvnAWpifQ6m74ZHAd3Fm5DMi2leYEEWf7Cnps9sFC7KHEBFZ-hIq4e2OQtcxB2IZ2xnv6zwYmS5CTTsAELyghwzq6UvrWCyGj6OOXapl3E',
  //       'priority': 'high',
  //       'notification': {
  //         'title': 'Booking Confirmation',
  //         'body': 'Update My Booking',
  //       },
  //       'data': {'id': id}
  //     };
  //     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         body: jsonEncode(data),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Authorization':
  //               'key=AAAAliCh-R8:APA91bGSDvwcL3obmsYq7k3A3ueBbHm-SNDdKt8Y9RMqA7Ywi2U4o72j6WRZMiEQF4GPhuYsNlqwH6-RMgvigiQbuXTq42sjuG4zySquDBk0gN-zyHbCeIwHMHNXhHxrfLDKG02tgrKt'
  //         });
  //   });
  // }
}
