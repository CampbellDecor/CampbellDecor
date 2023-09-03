import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});
  static const route = '/notificationscreen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isDataVisible = false;
  String? userName;
  String? address;
  Map<String, dynamic> service = Map();
  List<Map<String, dynamic>> subcollectionData = [];

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  void getDatas() async {
    final email = 'pinthushan71998@gmail.com';

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          // Update userName inside a setState to trigger UI update
          userName = querySnapshot.docs.first['name'];
          address = querySnapshot.docs.first['address'];
        });
      }
      print(userName);
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> getDocumentData(dynamic docID) async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(docID)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
    } else {
      print('Document does not exist');
    }
  }

  Future<void> getSubcollectionData(dynamic docID) async {
    var subcollectionSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(docID)
        .collection('service')
        .get();
    subcollectionSnapshot.docs.forEach((doc) {
      subcollectionData.add(doc.data() as Map<String, dynamic>);
    });
  }

  void toggleDataVisibility() {
    setState(() {
      isDataVisible = !isDataVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    // subcollectionData.forEach((data) {
    //   data.forEach((key, value) {
    //     print('$key: $value');
    //   });
    //   print('---');
    // });

    print('id is : ${message.data.values}');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(message.data.values.first)
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
                      // axisDirection: AxisDirection.down
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 700,
                          width: 450,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
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
                                Text(message.data.values.first.toString()),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        'Name : ${userName ?? "Loading..."}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        'Event Name : ${data!['name']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        'Event Date : ${DateFormat.yMd().format(data!['eventDate'].toDate())}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        'Address : $address',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        'Total Amount : Rs.${data!['paymentAmount']}0',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: Text(
                                        'Services : ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('bookings')
                                              .doc(message.data.values.first
                                                  .toString())
                                              .update({'status': 'active'});
                                        },
                                        child: const Text('Confirm')),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('bookings')
                                              .doc(message.data.values.first
                                                  .toString())
                                              .update({
                                            'status': 'cancelled'
                                          }).then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Reject')),
                                  ],
                                ),
                              ],
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
}
