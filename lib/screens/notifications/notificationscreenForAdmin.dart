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
    final email = await FirebaseAuth.instance.currentUser!.email;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
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
    subcollectionSnapshot.docs.forEach((orderDoc) {
      service = orderDoc.data() as Map<String, dynamic>;
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
    Map<String, dynamic> messageData = message.data;

    getSubcollectionData(messageData['id']);
    List<Widget> listItems = [];
    service.forEach((key, value) {
      listItems.add(
        ListTile(
          title: Text(
            key,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      );
    });
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
                    .doc(messageData['id'].toString())
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
                            height: 800,
                            width: 450,
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
                                  Text(message.data.values.first.toString()),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${messageData['head'].toString()}',
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
                                              '${messageData['body'].toString()}',
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
                                      keyLable('Address : '),
                                      Expanded(
                                        child: Container(
                                            width: 300,
                                            child: valueLable('$address')),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      keyLable('Total amount : '),
                                      valueLable(
                                          'Rs.${data!['paymentAmount']}0'),
                                    ],
                                  ),
                                  Row(
                                    children: [keyLable('Services : ')],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: LimitedBox(
                                      maxWidth: 300,
                                      maxHeight: 250,
                                      child: Container(
                                        // decoration:
                                        child: ListView(
                                          children: listItems,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            showInformationAlert(context,
                                                'If you cancel that is not save',
                                                () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text('Cancel')),
                                      ElevatedButton(
                                          onPressed: () async {
                                            saveNotification(
                                              messageData['id'],
                                              messageData['head'],
                                              messageData['body'],
                                              DateTime.parse(
                                                  messageData['dateTime']),
                                            );
                                          },
                                          child: const Text('save')),
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
