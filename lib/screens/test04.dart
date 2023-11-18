import 'package:flutter/material.dart';
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
                  'GMit4L8TxWyBofbyyfRF',
                  'Booking request',
                  'Your booking request has been received. We will notify you shortly with our response.',
                  'birthday',
                  5000,
                  DateTime.now());
            },
            child: Text('SendNotification')),
      ),
    );
  }
}
