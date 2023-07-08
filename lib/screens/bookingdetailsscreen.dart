import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref('booking');
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text("Fetch Data from Users"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                return Card(
                  color: const Color.fromARGB(50, 260, 250, 254),
                  child: ListTile(
                    title: Text(snapshot.child('name').value.toString()),
                    subtitle:
                        Text(snapshot.child('bookingNo').value.toString()),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
