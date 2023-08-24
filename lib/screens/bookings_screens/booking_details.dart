import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../reusable/reusable_methods.dart';
import 'booking_details_screen.dart';

class BookingScreen extends StatelessWidget {
  // Stream<List<Booking>> getUpcomingBookings() {
  //   FirebaseFirestore.instance
  //       .collection('bookings')
  //       .where('userID',
  //       isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //       .where('eventDate', isLessThan: DateTime.now())
  //       .snapshots();
  //
  // }
  //
  // Stream<List<Booking>> getExpiredBookings() {
  //   // Replace this with your actual stream of expired bookings
  //   // This stream should emit a list of expired bookings.
  // }

  @override
  Widget build(BuildContext context) {
    print('userID is : ${FirebaseAuth.instance.currentUser?.uid}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Active Bookings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userID',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('eventDate', isGreaterThanOrEqualTo: DateTime.now())
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!streamSnapshot.hasData ||
                    streamSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available.'));
                }
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(58, 30, 58, 30),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.pink
                            ], // Set your desired gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          child: Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          58, 10, 58, 0),
                                      child: Text(
                                        documentSnapshot['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                                  ),
                                ),
                                Center(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          58, 0, 58, 0),
                                      child: Text(
                                        DateFormat.yMd().format(
                                            documentSnapshot['date'].toDate()),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                                  ),
                                ),
                                Divider(
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 200,
                                    color: Colors.transparent,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (documentSnapshot['eventDate']
                                            .toDate()
                                            .isAfter(DateTime.now()
                                                .add(Duration(days: 14)))) {
                                          String bookingId =
                                              documentSnapshot.id;

                                          try {
                                            requestCancellation(bookingId);
                                          } catch (error) {
                                            print(
                                                'Error deleting booking: $error');
                                          }
                                        } else {
                                          showInformationAlert(
                                              context,
                                              'You are not eligible to get a full refund',
                                              BookingScreen());
                                        }
                                      },
                                      child: const Text('Cancel'),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Expird Bookings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userID',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('eventDate', isLessThan: DateTime.now())
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!streamSnapshot.hasData ||
                    streamSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available.'));
                }
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(58, 30, 58, 30),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue,
                              Colors.black45
                            ], // Set your desired gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          child: Container(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          58, 0, 58, 0),
                                      child: Text(
                                        documentSnapshot['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                                  ),
                                ),
                                Center(
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          58, 0, 58, 0),
                                      child: Text(
                                        DateFormat.yMd().format(
                                            documentSnapshot['date'].toDate()),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
