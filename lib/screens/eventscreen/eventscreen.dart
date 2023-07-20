import 'package:campbelldecor/reusable_widgets/reusable_methods.dart';
import 'package:campbelldecor/screens/eventScreen/religion.dart';
import 'package:campbelldecor/screens/eventScreen/servicesscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    print(_events.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Events ",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _events.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0.0),
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      color: const Color.fromARGB(50, 260, 260, 254),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: 120,
                          child: ListTile(
                            title: Text(
                              documentSnapshot['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            onTap: () {
                              if (documentSnapshot['name'] == 'Wedding') {
                                Navication(context, ReligionSelectScreen());
                              } else {
                                Navication(context, ServicesScreen());
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
