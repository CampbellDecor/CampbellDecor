import 'dart:ffi';
import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/reusable/reusable_widgets.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/color_util.dart';

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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getDocumentData(widget.id);
    });
  }

  Future<void> getDocumentData(dynamic docID) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('notification')
        .doc(docID)
        .get();

    if (documentSnapshot.exists) {
      setState(() {
        notificationData = documentSnapshot.data() as Map<String, dynamic>;
      });
    } else {
      print('Document does not exist');
    }
  }

  Future<Map<String, dynamic>> getSubcollectionData(dynamic docID) async {
    var subcollectionSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .doc('L7NjlSAofOj9TufUA8tW')
        .collection('service')
        .get();
    subcollectionSnapshot.docs.forEach((orderDoc) {
      service = orderDoc.data();
    });
    return service;
  }

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
                    .collection('bookings')
                    .doc('L7NjlSAofOj9TufUA8tW')
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
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${notificationData['head'].toString()}',
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
                                          width: 330,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                18.0, 0, 0, 0),
                                            child: Text(
                                              '${notificationData['body'].toString()}',
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
                                      keyLable('Event name : '),
                                      valueLable(data!['name']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      keyLable('Event date : '),
                                      valueLable(DateFormat.yMd()
                                          .format(data!['eventDate'].toDate())),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      keyLable('Total amount : '),
                                      valueLable(
                                          'Rs.${data!['paymentAmount']}0'),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LimitedBox(
                                      maxWidth: 300,
                                      maxHeight: 400,
                                      child: Container(
                                        // decoration:
                                        child:
                                            FutureBuilder<Map<String, dynamic>>(
                                          future: getSubcollectionData(
                                              notificationData['bookId']),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // If the Future is still running, show a loading indicator
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              List<Widget> listItems = [];
                                              service.forEach((key, value) {
                                                listItems.add(
                                                  ListTile(
                                                    title: Text(
                                                      key,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white70,
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 0, 0, 0),
                                                      child: Text(
                                                        value.toString(),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white54,
                                                            fontFamily:
                                                                'OpenSans',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                              // if (service.length != 0)
                                              return Container(
                                                child: Column(
                                                  children: [
                                                    keyLable('Services : '),
                                                    LimitedBox(
                                                      maxWidth: 300,
                                                      maxHeight: 350,
                                                      child: Container(
                                                        // decoration:
                                                        child: ListView(
                                                          children: listItems,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
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
