import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable/reusable_methods.dart';

class testing extends StatefulWidget {
  const testing({super.key});

  @override
  State<testing> createState() => _testingState();
}

class _testingState extends State<testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              fetchDataFromFirebase('bookings', 'eventDate',
                  FirebaseAuth.instance.currentUser!.uid);
            },
            child: Text('click'),
          ),
        ),
      ),
    );
  }
}
