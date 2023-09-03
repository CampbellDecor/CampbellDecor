import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../reusable/reusable_methods.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('userID is : ${FirebaseAuth.instance.currentUser?.uid}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          final activeBookings = <DocumentSnapshot>[];
          final expiredBookings = <DocumentSnapshot>[];
          final now = DateTime.now();

          for (final doc in streamSnapshot.data!.docs) {
            final DateTime eventDate = (doc['date'] as Timestamp).toDate();
            final String status = doc['status'];

            if (status == 'active' && eventDate.isBefore(now)) {
              activeBookings.add(doc);
            } else if (status == 'cancelled' || status == 'expired') {
              expiredBookings.add(doc);
            }
          }

          return ListView.builder(
            itemCount: activeBookings.length + expiredBookings.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Active Bookings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              } else if (index <= activeBookings.length) {
                final doc = activeBookings[index - 1];
                return buildBookingCard1(
                    context, doc, Colors.blue, Colors.pink);
              } else if (index == activeBookings.length + 1) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Expired Bookings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                final doc = expiredBookings[index - activeBookings.length - 2];
                return buildBookingCard(
                    context, doc, Colors.lightBlue, Colors.black45);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildBookingCard1(BuildContext context,
      DocumentSnapshot documentSnapshot, Color startColor, Color endColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(58, 10, 58, 10),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [startColor, endColor],
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
                      padding: const EdgeInsets.fromLTRB(58, 10, 58, 0),
                      child: Text(
                        documentSnapshot['name'],
                        style: const TextStyle(
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
                      padding: const EdgeInsets.fromLTRB(58, 0, 58, 0),
                      child: Text(
                        DateFormat.yMd()
                            .format(documentSnapshot['date'].toDate()),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // subtitle: Text('Upcoming on ${documentSnapshot.data[index].date.toString()}'),
                  ),
                ),
                const Divider(
                  thickness: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    color: Colors.transparent,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (documentSnapshot['eventDate'].toDate().isAfter(
                            DateTime.now().add(const Duration(days: 14)))) {
                          String bookingId = documentSnapshot.id;

                          try {
                            cancelInformationAlert(
                                context,
                                'Are you Confirm cancel',
                                BookingScreen(),
                                bookingId);
                          } catch (error) {
                            print('Error deleting booking: $error');
                          }
                        } else {
                          String bookingId = documentSnapshot.id;

                          cancelInformationAlert(
                              context,
                              'You are not eligible to get a full refund',
                              BookingScreen(),
                              bookingId);
                        }
                      },
                      child: const Text('Cancel'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
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
  }

  Widget buildBookingCard(BuildContext context,
      DocumentSnapshot documentSnapshot, Color startColor, Color endColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(58, 10, 58, 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [startColor, endColor],
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
                      padding: const EdgeInsets.fromLTRB(58, 0, 8, 0),
                      child: Text(
                        documentSnapshot['name'],
                        style: const TextStyle(
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
                      padding: const EdgeInsets.fromLTRB(58, 0, 8, 0),
                      child: Text(
                        DateFormat.yMd()
                            .format(documentSnapshot['date'].toDate()),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: Text(
                      documentSnapshot['status'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
