import 'package:campbelldecor/screens/bookingdetailsscreen.dart';
import 'package:campbelldecor/screens/events_screen/servicesscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../reusable/reusable_methods.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // final User? user = FirebaseAuth.instance.currentUser;
  final _events = FirebaseFirestore.instance
      .collection('bookings')
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    print('User ID : ${FirebaseAuth.instance.currentUser?.uid}');
    // print(_events.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "My Bookings ",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
        child: StreamBuilder(
          stream: _events.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    DateTime dateTime = documentSnapshot['date'].toDate();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: ExpansionTile(
                              title: Text(
                                documentSnapshot['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    color: Colors.pink),
                              ),
                              subtitle: Text(
                                DateFormat.yMd().format(dateTime),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blueAccent),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      30, 30, 30, 0.0),
                                  child: Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.all(10),
                                    // color: const Color.fromARGB(50, 260, 260, 254),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Container(
                                        height: 120,
                                        child: ListTile(
                                          title: Text(
                                            documentSnapshot['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                                color: Colors.pink),
                                          ),
                                          onTap: () {
                                            // Navigation(
                                            //     context, ServicesScreen());
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const Divider(),
                          // Container(
                          //   child: ExpansionTile(
                          //     title: Text(
                          //       documentSnapshot['name'],
                          //       style: const TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 28,
                          //           color: Colors.pink),
                          //     ),
                          //     subtitle: Text(
                          //       DateFormat.yMd().format(dateTime),
                          //       style: const TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 18,
                          //           color: Colors.blueAccent),
                          //     ),
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.fromLTRB(
                          //             30, 30, 30, 0.0),
                          //         child: Card(
                          //           elevation: 5,
                          //           margin: const EdgeInsets.all(10),
                          //           // color: const Color.fromARGB(50, 260, 260, 254),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(20),
                          //             child: Container(
                          //               height: 120,
                          //               child: ListTile(
                          //                 title: Text(
                          //                   documentSnapshot['name'],
                          //                   style: const TextStyle(
                          //                       fontWeight: FontWeight.bold,
                          //                       fontSize: 28,
                          //                       color: Colors.pink),
                          //                 ),
                          //                 onTap: () {
                          //                   Navigation(
                          //                       context, ServicesScreen());
                          //                 },
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            Navigation(context, const BookingDetailsScreen());

            Future.delayed(const Duration(seconds: 2), () {
              // Navigate to next page
              Navigation(context, const BookingDetailsScreen());
            });
          },
          child: const Text('Next')),
    );
  }
}
