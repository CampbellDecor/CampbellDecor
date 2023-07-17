// import 'package:campbelldecor/screens/bookingdetailsscreen.dart';
// import 'package:campbelldecor/screens/homescreen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
//
// class BookingScreen extends StatelessWidget {
//   BookingScreen({super.key});
//   final ref = FirebaseDatabase.instance.ref('booking');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       appBar: AppBar(
//         title: Text("My Booking"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(28.0),
//               child: FirebaseAnimatedList(
//                 query: ref,
//                 itemBuilder: (context, snapshot, animation, index) {
//                   return Card(
//                     color: Color.fromARGB(50, 260, 250, 254),
//                     child: ListTile(
//                       title: Text(snapshot.child('name').value.toString()),
//                       subtitle:
//                           Text(snapshot.child('bookingNo').value.toString()),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BookingDetailsScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Text("Old"),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: FirebaseAnimatedList(
//                 query: ref,
//                 itemBuilder: (context, snapshot, animation, index) {
//                   return Card(
//                     color: Color.fromARGB(50, 260, 250, 254),
//                     child: ListTile(
//                       title: Text(snapshot.child('name').value.toString()),
//                       subtitle:
//                           Text(snapshot.child('bookingNo').value.toString()),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BookingDetailsScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:campbelldecor/resources/loader.dart';
import 'package:campbelldecor/reusable_widgets/reusable_methods.dart';
import 'package:campbelldecor/screens/bookingdetailsscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  // BookingScreen({super.key});

  final CollectionReference _booking =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    print(_booking.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("My Booking"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _booking.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        color: const Color.fromARGB(50, 102, 187, 106),
                        child: ListTile(
                          title: Text(documentSnapshot['name']),
                          subtitle:
                              Text(documentSnapshot['phoneno'].toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookingDetailsScreen()));
                          },
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return PageLoader();
                  },
                );
                Future.delayed(Duration(seconds: 2), () {
                  // Navigate to next page
                  Navication(context, BookingDetailsScreen());
                });
              },
              child: Text('Next')),
        ],
      ),
    );
  }
}
