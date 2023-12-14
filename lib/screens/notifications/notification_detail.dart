import 'package:campbelldecor/reusable/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../reusable/reusable_methods.dart';
import '../../utils/color_util.dart';
import '../bookings_screens/booking_details_screen.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final String id;
  NotificationDetailsScreen({super.key, required this.id});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  String? userName;
  String? address;
  Map<String, dynamic> service = Map();
  Map<String, dynamic> notificationData = Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CB2893"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61F4")
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notification')
                    .doc(widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Text('Document not found.');
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  var data = snapshot.data!.data();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 8,
                          child: Container(
                            constraints: BoxConstraints(minHeight: 350),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.pink],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 30, 20, 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${data!['head']}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 0, 8, 0),
                                        child: Container(
                                          width: 320,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                18.0, 0, 0, 0),
                                            child: Text(
                                              '${data!['body']}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white70,
                                                  fontFamily: 'OpenSans',
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      keyLable('Name : '),
                                      valueLable(data!['name']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      keyLable('Event date : '),
                                      valueLable(DateFormat.yMd().format(
                                          data!['eventDateTime'].toDate())),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      keyLable('Total amount : '),
                                      valueLable('\$${data!['payment']}0'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigation(
                                                context, BookingScreen());
                                          },
                                          child: valueLable(
                                              'check your booking history'))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteData(String id) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('notification');

    try {
      await collection.doc(id).delete();
      print('Document deleted successfully!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
