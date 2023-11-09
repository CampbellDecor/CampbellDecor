import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../reusable/reusable_methods.dart';

class testdelete extends StatelessWidget {
  const testdelete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setOutDatedBooking();
          },
          child: Text("delete"),
        ),
      ),
    );
  }
}
