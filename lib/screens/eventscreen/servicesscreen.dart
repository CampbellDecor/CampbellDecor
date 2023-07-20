import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');
  @override
  Widget build(BuildContext context) {
    print(_services.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Services",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _services.snapshots(),
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
                      elevation: 10,
                      shadowColor: Colors.black,
                      margin: const EdgeInsets.all(10),
                      color: const Color.fromARGB(245, 0, 150, 136),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: 120,
                          child: ListTile(
                            title: Text(
                              documentSnapshot['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                                'Price : Rs${documentSnapshot['price']}.00'),
                            onTap: () {},
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
