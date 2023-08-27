import 'dart:convert';

import 'package:campbelldecor/screens/notifications/notification_services.dart';
import 'package:campbelldecor/screens/notifications/welcomeNotification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
              sendNotification();
            },
            child: Text('SendNotification')),
      ),
    );
  }

  void sendNotification() {
    final NotificationServices notificationServices = NotificationServices();
    notificationServices.getDeviceToken().then((value) async {
      var data = {
        'to':
            'emHO-ms5RxqdWIxch_QGsJ:APA91bFVXTHvikBswj9E8Ug2HyLN8kbcStQ5bmCrER1DTxrBN87kbezlAi2vtDbxwR4iXx5lhd7Ni3c1AOW8tsnGZFwHyXha3LKsmCAGqMBA3byzsyV7aX63Vy-ECyMbpm6pjfkiomtJ',
        'priority': 'high',
        'notification': {
          'title': 'Pinthushan',
          'body': 'Subscripe to my Channel',
        },
        'data': {'type': 'msj', 'id': 'pinthu07'}
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAliCh-R8:APA91bGSDvwcL3obmsYq7k3A3ueBbHm-SNDdKt8Y9RMqA7Ywi2U4o72j6WRZMiEQF4GPhuYsNlqwH6-RMgvigiQbuXTq42sjuG4zySquDBk0gN-zyHbCeIwHMHNXhHxrfLDKG02tgrKt'
          });
    });
  }
}
