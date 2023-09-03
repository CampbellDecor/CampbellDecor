import 'dart:convert';

import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/bookings_screens/booking_screen.dart';
import 'package:campbelldecor/screens/bookings_screens/cart_screen.dart';
import 'package:campbelldecor/screens/events_screen/serviceselectscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesScreen extends StatefulWidget {
  final DateTime eventDate;
  ServicesScreen({required this.eventDate});

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
  String? event;
  final uid = 'AxlSnuQWsQQ73IVY4YxB0d0Ispx2';
  // FirebaseAuth.instance.currentUser!.uid;
  _resetAndNavigateBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(_services.toString());
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _resetAndNavigateBack,
        ),
        title: Text('Our Services'),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _services.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return LimitedBox(
                  maxHeight: 680,
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
                        });
                      });
                      amount = await getDoubleData('amount');
                      event = await getData('event');
                      /*---------------------insert Add to cart Collection---------------------*/
                      if (amount != null && amount! > 0) {
                        await insertData(
                                'bookings',
                                event!,
                                'cart',
                                uid,
                                DateTime.now(),
                                widget.eventDate,
                                amount!,
                                myMap)
                            .then((value) async {
                          Navigation(context, AddToCartScreen());
                        });
                      } else if (amount == null) {
                        showInformation(context, 'Please Select Services');
                      }
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
                      await getMapData('service').then((map) {
                        setState(() {
                          myMap = map;
                        });
                      });
                      event = await getData('event');
                      amount = await getDoubleData('amount');
                      /*---------------------insert Booking Collection---------------------*/
                      if (amount != null && amount! > 0) {
                        await insertData(
                                'bookings',
                                event!,
                                'pending',
                                uid,
                                DateTime.now(),
                                widget.eventDate,
                                amount!,
                                myMap)
                            .then((value) async {
                          Navigation(context, BookingScreen());
                        });
                      } else {
                        showInformation(context, 'Please Select Services');
                      }
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
