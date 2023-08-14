import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/cartscreen.dart';
import 'package:campbelldecor/screens/events_screen/serviceselectscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  final String event;
  ServicesScreen({required this.event});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');
  //----------------------------------------
  Map<String, dynamic> data = {};
  Map<String, dynamic> myMap = {};
  double? amount;
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
      body: Column(
        children: [
          StreamBuilder(
            stream: _services.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return LimitedBox(
                  maxHeight: 700,
                  child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 10,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    documentSnapshot['imgURL'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      //----------------------Text Container background ----------------------//

                                      title: Container(
                                        height: 70,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        //----------------------Text Editings----------------------//
                                        child: Text(
                                          documentSnapshot['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigation(
                                            context,
                                            ServiceSelectScreen(
                                              map: data,
                                              data: documentSnapshot['name'],
                                              id: documentSnapshot.id,
                                            ));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 8, 0, 8),
                child: Container(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      /*--------------------- Add services into myMap ---------------------*/
                      await getMapData('service').then((map) {
                        setState(() {
                          myMap = map;
                          // myMap.forEach((key, value) {
                          //   print('Key: $key, Value: $value');
                          // });
                        });
                      });
                      /*---------------------insert Booking Collection---------------------*/

                      await insertData(
                              'addtocart',
                              widget.event,
                              FirebaseAuth.instance.currentUser!.uid,
                              DateTime.now(),
                              'Event date',
                              500,
                              myMap)
                          .then((value) =>
                              Navigation(context, AddToCartScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text('Add To Cart'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 40, 8),
                child: Container(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      /*--------------------- Add services into myMap ---------------------*/
                      getMapData('service').then((map) {
                        setState(() {
                          myMap = map;
                          // myMap.forEach((key, value) {
                          //   print('Key: $key, Value: $value');
                          // });
                        });
                      });
                      /*---------------------insert Booking Collection---------------------*/

                      insertData(
                          'bookings',
                          widget.event,
                          FirebaseAuth.instance.currentUser!.uid,
                          DateTime.now(),
                          'Event date',
                          500,
                          myMap);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text('Book'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
